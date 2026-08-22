<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-dark navbar-blood sticky-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fa-solid fa-droplet brand-icon"></i>
            <span>Blood<span style="color: var(--primary-red);">Bridge</span></span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.endsWith('index.jsp') || pageContext.request.requestURI.endsWith('/') ? 'active' : ''}" href="${pageContext.request.contextPath}/">
                        <i class="fa-solid fa-house me-1"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/search') ? 'active' : ''}" href="${pageContext.request.contextPath}/search">
                        <i class="fa-solid fa-magnifying-glass me-1"></i> Find Donors
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/request/list') ? 'active' : ''}" href="${pageContext.request.contextPath}/request/list">
                        <i class="fa-solid fa-hand-holding-hand me-1"></i> Blood Requests
                    </a>
                </li>

                <c:if test="${not empty sessionScope.user && sessionScope.user.isDonor()}">
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('/donor/dashboard') ? 'active' : ''}" href="${pageContext.request.contextPath}/donor/dashboard">
                            <i class="fa-solid fa-user-doctor me-1"></i> Donor Dashboard
                        </a>
                    </li>
                </c:if>

                <c:if test="${not empty sessionScope.user && sessionScope.user.isRecipient()}">
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('/recipient/dashboard') ? 'active' : ''}" href="${pageContext.request.contextPath}/recipient/dashboard">
                            <i class="fa-solid fa-heart-pulse me-1"></i> Recipient Dashboard
                        </a>
                    </li>
                </c:if>

                <c:if test="${not empty sessionScope.user && sessionScope.user.isAdmin()}">
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('/admin/dashboard') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fa-solid fa-shield-halved me-1"></i> Admin Panel
                        </a>
                    </li>
                </c:if>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-blood-outline btn-sm px-4">Log In</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-blood-danger btn-sm px-4">Register</a>
                    </c:when>
                    <c:otherwise>
                        <div class="dropdown">
                            <button class="btn btn-blood-outline btn-sm dropdown-toggle d-flex align-items-center gap-2" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-solid fa-circle-user text-danger"></i>
                                <span><c:out value="${sessionScope.user.name}" /></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end shadow-lg" aria-labelledby="userMenu">
                                <li>
                                    <span class="dropdown-item-text text-muted small">Role: <strong><c:out value="${sessionScope.user.role}" /></strong></span>
                                </li>
                                <li><hr class="dropdown-divider border-secondary"></li>
                                <c:if test="${sessionScope.user.isDonor()}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/donor/dashboard"><i class="fa-solid fa-gauge me-2"></i>Dashboard</a></li>
                                </c:if>
                                <c:if test="${sessionScope.user.isRecipient()}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/recipient/dashboard"><i class="fa-solid fa-gauge me-2"></i>Dashboard</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/request/create"><i class="fa-solid fa-plus me-2"></i>New Request</a></li>
                                </c:if>
                                <c:if test="${sessionScope.user.isAdmin()}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-user-shield me-2"></i>Admin Console</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider border-secondary"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket me-2"></i>Sign Out</a></li>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<!-- Global Toast Notification Banner -->
<div class="container mt-3">
    <c:if test="${not empty sessionScope.toastSuccess}">
        <div class="alert alert-success alert-dismissible fade show glass-card border-success text-success" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> <c:out value="${sessionScope.toastSuccess}" />
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="toastSuccess" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.toastError}">
        <div class="alert alert-danger alert-dismissible fade show glass-card border-danger text-danger" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i> <c:out value="${sessionScope.toastError}" />
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="toastError" scope="session" />
    </c:if>
</div>
