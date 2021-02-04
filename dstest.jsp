<%@page import="java.sql.Types"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		if (request.getParameter("jndiName") != null) {
		//  	PrintWriter writer = response.getWriter();
		out.write("<h1>Results of Test</h1>");
		String jndiName = request.getParameter("jndiName");

		try {
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup(jndiName);
			out.write("<p>Successfully looked up DataSource named " + jndiName + "</p>");

			if (request.getParameter("tableName") != null) {
		String tableName = request.getParameter("tableName");
		Connection conn = null;
		Statement stmt = null;

		conn = ds.getConnection();
		out.write("<p>Successfully connected to database.</p>");
		stmt = conn.createStatement();
		String query = "SELECT * FROM " + tableName;
		out.write("<p>Attempting query \"" + query + "\"</p>");
		ResultSet results = stmt.executeQuery(query);
		ResultSetMetaData rsMetaData = results.getMetaData();
		int numberOfColumns = rsMetaData.getColumnCount();

		out.write("<table><tr>");
		//Display the header row of column names
		for (int i = 1; i <= numberOfColumns; i++) {
			int columnType = rsMetaData.getColumnType(i);
			String columnName = rsMetaData.getColumnName(i);
			if (columnType == Types.VARCHAR) {
				out.write("<td>" + columnName + "</td>");
			}
		}
		out.write("</tr>");
		//Print the values (VARCHAR's only) of each result
		while (results.next()) {
			out.write("<tr>");
			for (int i = 1; i <= numberOfColumns; i++) {
				int columnType = rsMetaData.getColumnType(i);
				String columnName = rsMetaData.getColumnName(i);
				if (columnType == Types.VARCHAR) {
					out.write("<td>" + results.getString(columnName) + "</td>");
				}
			}
			out.write("</tr>");
		}
		out.write("</table>");
		stmt.close();
		conn.close();
			}
		} catch (Exception e) {
			out.write("An exception was thrown: " + e.getMessage() + "<br>");
			e.printStackTrace();
		}
	} else {
	%>
	<h1>Test an Datasource</h1>
	<form method="post">
		<table>
			<tr>
				<td>JNDI Name of Datasource:</td>
				<td><input type="text" width="60" name="jndiName" /></td>
			</tr>
			<tr>
				<td>Table Name to Query (optional):</td>
				<td><input type="text" width="60" name="tableName" /></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="submit" value="Submit" name="submit" /></td>
			</tr>
		</table>
	</form>
	<%
		}
	%>
</body>
</html>