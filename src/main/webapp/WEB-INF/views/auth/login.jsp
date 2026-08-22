<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Log In - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5 my-auto">
    <div class="row justify-content-center">
        <div class="col-lg-5 col-md-7">
            <div class="glass-card p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="blood-badge mx-auto mb-3">
                        <i class="fa-solid fa-right-to-bracket"></i>
                    </div>
                    <h3 class="text-white fw-bold">Welcome Back</h3>
                    <p class="text-secondary small">Access your BloodBridge donor or recipient portal</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger glass-card border-danger text-danger p-3 mb-3 small" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-1"></i> <c:out value="${errorMessage}" />
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success glass-card border-success text-success p-3 mb-3 small" role="alert">
                        <i class="fa-solid fa-circle-check me-1"></i> <c:out value="${successMessage}" />
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="POST" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label class="form-label text-secondary small fw-bold">EMAIL ADDRESS</label>
                        <div class="input-group">
                            <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-envelope"></i></span>
                            <input type="email" name="email" class="form-control form-control-dark" placeholder="name@example.com" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-secondary small fw-bold">PASSWORD</label>
                        <div class="input-group">
                            <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-lock"></i></span>
                            <input type="password" name="password" class="form-control form-control-dark" placeholder="••••••••" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-blood-danger w-100 py-3 font-semibold mb-3">
                        Log In to Account <i class="fa-solid fa-arrow-right ms-2"></i>
                    </button>

                    <div class="text-center">
                        <p class="text-secondary small mb-0">
                            Don't have an account? <a href="${pageContext.request.contextPath}/register" class="text-danger text-decoration-none fw-bold">Register Here</a>
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
