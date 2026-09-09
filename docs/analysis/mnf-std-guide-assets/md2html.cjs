// Minimal Markdown -> HTML converter for this guide's subset (pandoc is unavailable here).
// Supports: frontmatter, h1-h3, paragraphs, pipe tables, ordered/unordered lists,
// blockquotes, images, links, bold, inline code, raw HTML blocks.
const fs=require('node:fs');
const path=require('node:path');

const esc=s=>s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
const attr=s=>esc(s).replace(/"/g,'&quot;');

function inline(s,ctx){
 const codes=[];
 s=s.replace(/`([^`]+)`/g,(m,c)=>{codes.push(c);return '\u0000'+(codes.length-1)+'\u0000';});
 s=esc(s);
 s=s.replace(/\[([^\]]+)\]\(([^)]+)\)/g,(m,t,h)=>{ctx&&ctx.links.push(h);return `<a href="${attr(h)}">${t}</a>`;});
 s=s.replace(/\*\*([^*]+)\*\*/g,'<strong>$1</strong>');
 s=s.replace(/\u0000(\d+)\u0000/g,(m,i)=>`<code>${esc(codes[+i])}</code>`);
 return s;
}

function embedImage(src,base){
 const file=path.resolve(base,decodeURI(src));
 if(!fs.existsSync(file))throw new Error('Missing image: '+src);
 const buf=fs.readFileSync(file);
 return 'data:image/svg+xml;base64,'+buf.toString('base64');
}

function convert(md,opts){
 const base=opts.base;
 const ctx={links:[],images:0};
 let meta={};
 if(md.startsWith('---\n')){
  const end=md.indexOf('\n---\n',4);
  const head=md.slice(4,end);
  md=md.slice(end+5);
  for(const line of head.split('\n')){
   const m=line.match(/^(\w+):\s*"?(.*?)"?$/);
   if(m)meta[m[1]]=m[2];
  }
 }
 const lines=md.split('\n');
 const out=[];const toc=[];let n=0;
 for(let i=0;i<lines.length;i++){
  let line=lines[i];
  if(!line.trim()){continue;}
  // raw html block
  if(/^<\w/.test(line)){out.push(line);continue;}
  // heading
  let m=line.match(/^(#{1,3})\s+(.*)$/);
  if(m){
   n++;const id='section-'+String(n).padStart(2,'0');
   const level=m[1].length;
   const title=inline(m[2],ctx);
   out.push(`<h${level} id="${id}">${title}</h${level}>`);
   toc.push({level,id,title});
   continue;
  }
  // image (own paragraph) -> figure
  m=line.match(/^!\[([^\]]*)\]\(([^)]+)\)\s*$/);
  if(m){
   const alt=attr(m[1]);
   const uri=embedImage(m[2],base);ctx.images++;
   out.push(`<figure>\n<img role="img" aria-label="${alt}" src="${uri}" alt="${alt}" />\n<figcaption aria-hidden="true">${esc(m[1])}</figcaption>\n</figure>`);
   continue;
  }
  // blockquote
  if(line.startsWith('> ')){
   const buf=[];
   while(i<lines.length&&lines[i].startsWith('> ')){buf.push(lines[i].slice(2));i++;}
   i--;
   out.push('<blockquote>\n<p>'+buf.map(b=>inline(b,ctx)).join('<br />\n')+'</p>\n</blockquote>');
   continue;
  }
  // table
  if(line.startsWith('|')&&/^\|[\s:|-]+\|$/.test(lines[i+1]||'')){
   const cells=r=>r.replace(/^\||\|$/g,'').split('|').map(c=>c.trim());
   const head=cells(line);i+=2;
   const body=[];
   while(i<lines.length&&lines[i].startsWith('|')){body.push(cells(lines[i]));i++;}
   i--;
   const cls=body.length<=8?' class="keep-table"':'';
   out.push(`<table${cls}>\n<thead>\n<tr>${head.map(h=>`<th>${inline(h,ctx)}</th>`).join('')}</tr>\n</thead>\n<tbody>\n`
    +body.map(r=>`<tr>${r.map(c=>`<td>${inline(c,ctx)}</td>`).join('')}</tr>`).join('\n')
    +'\n</tbody>\n</table>');
   continue;
  }
  // lists
  m=line.match(/^(\d+)\.\s+(.*)$/);
  if(m){
   const items=[];
   while(i<lines.length&&/^\d+\.\s+/.test(lines[i])){items.push(lines[i].replace(/^\d+\.\s+/,''));i++;}
   i--;
   out.push('<ol>\n'+items.map(t=>`<li>${inline(t,ctx)}</li>`).join('\n')+'\n</ol>');
   continue;
  }
  if(/^-\s+/.test(line)){
   const items=[];
   while(i<lines.length&&/^-\s+/.test(lines[i])){items.push(lines[i].replace(/^-\s+/,''));i++;}
   i--;
   out.push('<ul>\n'+items.map(t=>`<li>${inline(t,ctx)}</li>`).join('\n')+'\n</ul>');
   continue;
  }
  out.push('<p>'+inline(line,ctx)+'</p>');
 }
 // TOC: h1 + h2 only
 let tocHtml='<nav id="TOC" role="doc-toc">\n<h2 id="toc-title">읽는 순서</h2>\n<ul>\n';
 let open=false;
 for(const t of toc){
  if(t.level===1){
   if(open){tocHtml+='</ul></li>\n';open=false;}
   tocHtml+=`<li><a href="#${t.id}" id="toc-${t.id}">${t.title}</a>`;
   const next=toc[toc.indexOf(t)+1];
   if(next&&next.level===2){tocHtml+='\n<ul>\n';open=true;}else tocHtml+='</li>\n';
  }else if(t.level===2&&open){
   tocHtml+=`<li><a href="#${t.id}" id="toc-${t.id}">${t.title}</a></li>\n`;
  }
 }
 if(open)tocHtml+='</ul></li>\n';
 tocHtml+='</ul>\n</nav>';
 const css=fs.readFileSync(path.join(opts.assets,'guide.css'),'utf8');
 const header=`<header id="title-block-header">\n<h1 class="title">${esc(meta.title||'')}</h1>\n<p class="subtitle">${esc(meta.subtitle||'')}</p>\n<p class="date">${esc(meta.date||'')}</p>\n</header>`;
 const html=`<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes" />
  <meta name="dcterms.date" content="${attr(meta.date||'')}" />
  <title>${esc(meta.title||'')}</title>
  <style type="text/css">${css}</style>
</head>
<body>
${header}
${opts.shortcuts||''}
${tocHtml}
${out.join('\n')}
</body>
</html>
`;
 return {html,toc,ctx,meta};
}
module.exports={convert};
