<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Active Blood Requests - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
        <div>
            <h2 class="text-white fw-bold mb-1"><i class="fa-solid fa-hand-holding-droplet text-danger me-2"></i> All Active Blood Requests</h2>
            <p class="text-secondary small mb-0">Browse open emergency requests across hospitals and locations</p>
        </div>
        <a href="${pageContext.request.contextPath}/request/create" class="btn btn-blood-danger py-2 px-4">
            <i class="fa-solid fa-plus-circle me-2"></i> Post Request
        </a>
    </div>

    <div class="glass-card p-4">
        <c:choose>
            <c:when test="${not empty requestsList}">
                <div class="table-responsive">
                    <table class="table table-dark-custom align-middle">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Blood Group</th>
                                <th>Units</th>
                                <th>Hospital</th>
                                <th>City / State</th>
                                <th>Urgency</th>
                                <th>Status</th>
                                <th>Posted Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${requestsList}">
                                <tr>
                                    <td><strong class="text-white"><c:out value="${req.patientName}" /></strong></td>
                                    <td><span class="badge bg-danger fs-6"><c:out value="${req.bloodGroup}" /></span></td>
                                    <td><c:out value="${req.unitsNeeded}" /></td>
                                    <td><strong class="text-white"><c:out value="${req.hospitalName}" /></strong></td>
                                    <td><c:out value="${req.city}" />, <c:out value="${req.state}" /></td>
                                    <td><span class="badge badge-urgency-${req.urgency.toLowerCase()}"><c:out value="${req.urgency}" /></span></td>
                                    <td><span class="badge badge-status-${req.status.toLowerCase()}"><c:out value="${req.status}" /></span></td>
                                    <td class="text-secondary small"><c:out value="${req.createdAt}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user && sessionScope.user.isDonor()}">
                                                <a href="${pageContext.request.contextPath}/donor/dashboard" class="btn btn-blood-danger btn-sm">Respond</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/login" class="btn btn-blood-outline btn-sm">Log In to Respond</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 text-secondary">
                    <i class="fa-solid fa-check-double display-4 mb-3 text-success"></i>
                    <p class="mb-0">There are currently no active blood requests.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
