<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Donor Responses - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5">
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/recipient/dashboard" class="text-secondary text-decoration-none small">
            <i class="fa-solid fa-arrow-left me-1"></i> Back to Dashboard
        </a>
        <h2 class="text-white fw-bold mt-2">Responses for Request #${bloodReq.requestId}</h2>
        <p class="text-secondary small mb-0">
            Patient: <strong><c:out value="${bloodReq.patientName}" /></strong> | Blood Needed: <span class="badge bg-danger"><c:out value="${bloodReq.bloodGroup}" /></span> | Hospital: <strong><c:out value="${bloodReq.hospitalName}" /></strong>
        </p>
    </div>

    <div class="glass-card p-4">
        <h4 class="text-white mb-4"><i class="fa-solid fa-user-check text-success me-2"></i> Responding Voluntary Donors</h4>

        <c:choose>
            <c:when test="${not empty responses}">
                <div class="row g-4">
                    <c:forEach var="resp" items="${responses}">
                        <div class="col-md-6 col-lg-4">
                            <div class="glass-card p-4 border border-secondary border-opacity-30 h-100">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="blood-badge">
                                            <c:out value="${resp.donor.bloodGroup}" />
                                        </div>
                                        <div>
                                            <h5 class="text-white mb-0 fw-bold"><c:out value="${resp.donor.user.name}" /></h5>
                                            <span class="text-secondary small"><c:out value="${resp.donor.city}" />, <c:out value="${resp.donor.state}" /></span>
                                        </div>
                                    </div>
                                    <span class="badge badge-status-${resp.status.toLowerCase()}"><c:out value="${resp.status}" /></span>
                                </div>

                                <div class="p-3 bg-black bg-opacity-30 rounded mb-3">
                                    <span class="text-secondary small d-block mb-1">DONOR MESSAGE:</span>
                                    <p class="text-white small mb-0 fst-italic">"<c:out value="${resp.message != null && !resp.message.isEmpty() ? resp.message : 'Available to donate immediately.'}" />"</p>
                                </div>

                                <div class="mb-3 small">
                                    <div class="text-secondary mb-1">
                                        <i class="fa-solid fa-phone text-danger me-2"></i> Phone: 
                                        <a href="tel:${resp.donor.user.phone}" class="text-white text-decoration-none fw-bold"><c:out value="${resp.donor.user.phone}" /></a>
                                    </div>
                                    <div class="text-secondary mb-1">
                                        <i class="fa-solid fa-envelope text-info me-2"></i> Email: 
                                        <a href="mailto:${resp.donor.user.email}" class="text-white text-decoration-none"><c:out value="${resp.donor.user.email}" /></a>
                                    </div>
                                    <div class="text-secondary">
                                        <i class="fa-solid fa-calendar me-2"></i> Last Donated: <c:out value="${resp.donor.lastDonationDate != null ? resp.donor.lastDonationDate : 'Never'}" />
                                    </div>
                                </div>

                                <div class="d-flex gap-2 mt-auto pt-2">
                                    <form action="${pageContext.request.contextPath}/request/update-status" method="POST" class="w-50">
                                        <input type="hidden" name="responseId" value="${resp.responseId}">
                                        <input type="hidden" name="status" value="ACCEPTED">
                                        <button type="submit" class="btn btn-success btn-sm w-100"><i class="fa-solid fa-check me-1"></i> Accept</button>
                                    </form>
                                    <a href="tel:${resp.donor.user.phone}" class="btn btn-blood-danger btn-sm w-50"><i class="fa-solid fa-phone me-1"></i> Call Donor</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 text-secondary">
                    <i class="fa-solid fa-user-clock display-4 mb-3 text-warning"></i>
                    <p class="mb-0">No donors have responded to this request yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
