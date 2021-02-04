<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WebTest</title>
</head>
<body>
    <h1>Session Tracking Test</h1>
    Session tracking with JSP is easy
    <P>
	<%@ page session="true" %>
	<%
      	// Get the session data value
    	Integer ival = (Integer) session.getValue ("counter");
		if (ival == null) ival = new Integer (1);
		else ival = new Integer (ival.intValue() + 1);
		session.putValue ("counter", ival);
		
	%>
	<h4>jvmRoute Name : <%=session.getId().substring(session.getId().indexOf(".") + 1) %></h4>
    You have hit this page <%= ival %> times.<br>
	<%
    	out.println("Your Session ID is " + session.getId() +  "<br>");
		System.out.println("\n[SESSION_ID][" + session.getId() + "][COUNTER][" + ival + "]");
	%>
</body>
</html>