<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BloodBridge - Life-Saving Blood Donation Platform connecting donors with recipients and hospitals.">
    <title><c:out value="${pageTitle != null ? pageTitle : 'BloodBridge - Blood Donation Platform'}" /></title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Custom BloodBridge Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">

    <script>
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
</head>
<body>
