package com.poscoict.glue.biz.dhtmlx.converter;

import java.util.Map;

import com.poscoict.glue.dhtmlx.constant.DhtmlxConstantsIF;
import com.posdata.glue.context.PosContext;
import com.posdata.glue.dao.vo.PosRowSetImpl;

public class GridJsonConverter {

	public String convert(PosContext ctx) {
		StringBuffer sb = new StringBuffer();

		sb.append("{");
		sb.append(makeUserdata(ctx));
		sb.append(makeGrid(ctx));

		sb.append("}");

		return sb.toString().trim();
	}

	public String makeUserdata(PosContext ctx) {
		StringBuffer sb = new StringBuffer();

		sb.append("\"column-info\":\"").append(getColumnInfo(ctx))
				.append("\",\n");
		sb.append("\"blank-row-count\":\"").append(getBlankRowCount(ctx))
				.append("\",\n");

		/* Application Message */
		Object appMsg = ctx.get("appMsg") != null ? ctx.get("appMsg") : "";
		sb.append("\"appMsg\":\"").append(appMsg).append("\",\n");

		/* Error Message */
		Throwable error = ctx.getException();
		if (error != null) {
			sb.append("\"errMsg\":\"").append("SQL 오류가 발생 했습니다.")
					.append("\",\n");
		}

		return sb.toString().trim();
	}

	public String getColumnInfo(PosContext ctx) {
		return ctx.get("column-info") != null ? (String) ctx.get("column-info")
				: "";
	}

	public String getBlankRowCount(PosContext ctx) {
		String[] blkRowCnt = (String[]) ctx.get("blank-row-count");

		String blankRowCntParam = (blkRowCnt != null
				&& !blkRowCnt[0].equals("null") && !blkRowCnt[0].equals("")) ? blkRowCnt[0]
				: "0";
		return blankRowCntParam;
	}

	/**
	 * @param ctx
	 * @return String
	 */
	public String makeGrid(PosContext ctx) {
		StringBuffer sb = new StringBuffer();

		String resultKey = "xml-result";

		PosRowSetImpl rowList = (PosRowSetImpl) ctx.get(resultKey);

		sb.append("rows:[");

		if (rowList == null || rowList.size() == 0) {
			int blankRowCount = Integer.parseInt(getBlankRowCount(ctx));
			sb.append(makeBlankRow(blankRowCount));
		} else {
			String[] colOrder = getColumnInfo(ctx).split(",");

			int index = 0; // startRowNum
			Map row = null;
			Object cellData = null;
			for (int i = 0, listSize = rowList.size(); i < listSize; i++) {
				row = (Map) rowList.get(i);

				sb.append("{id:\"").append(resultKey + "_" + index++);
				sb.append("\", data:[");
				Object tooltipData = "";
				for (int j = 0; j < colOrder.length; j++) {

					boolean tooltipFlag = colOrder[j].matches(".*TOOLTIP");// tooltip
																			// check
					if (tooltipFlag) {

						tooltipData = row.get(colOrder[j]);
						j += 1; // loop index plus
						cellData = row.get(colOrder[j]);

					} else {
						cellData = row.get(colOrder[j]);
					}

					if (tooltipFlag && tooltipData != null) {
						sb.append("{\"value\":").append("\"" + cellData + "\"")
								.append(",\"bgColor\":\"red\"")
								.append(",\"title\":\"" + tooltipData + "\"}");
					} else {
						if (cellData != null)
							sb.append("\"").append(cellData).append("\"");
						else if (DhtmlxConstantsIF.CHK_TYPE.equals(colOrder[j]))
							sb.append("\"0\"");
						else if (DhtmlxConstantsIF.NUM_TYPE.equals(colOrder[j]))
							sb.append("\"").append(index).append("\"");
						else
							sb.append("\"\"");
					}

					if (j < colOrder.length - 1) {
						sb.append(",");
					}
				}

				if (i == listSize - 1) {
					sb.append("]}\n");
				} else {
					sb.append("]},\n");
				}
			}
		}

		sb.append("]");

		return sb.toString().trim();
	}

	public String makeBlankRow(int rowCount) {
		StringBuffer sb = new StringBuffer();

		for (int i = 0; i < rowCount; i++) {
			sb.append("{id:\"").append(i).append("\"");

			if (i == rowCount - 1) {
				sb.append(",data:[]}\n");
			} else {
				sb.append(",data:[]},\n");
			}
		}

		return sb.toString().trim();
	}
}