<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="404 Page Not Found - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5 my-auto text-center">
    <div class="glass-card p-5 max-w-lg mx-auto">
        <h1 class="display-1 fw-extrabold text-danger mb-2">404</h1>
        <h3 class="text-white mb-3">Page Not Found</h3>
        <p class="text-secondary mb-4">
            The page or donation resource you are searching for does not exist or has been moved.
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-blood-danger px-4 py-2">
            <i class="fa-solid fa-house me-2"></i> Return to Homepage
        </a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
