<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Recipient Dashboard - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
        <div>
            <h2 class="text-white fw-bold mb-1">Recipient Dashboard</h2>
            <p class="text-secondary small mb-0">Manage your blood donation requests and view responding donors</p>
        </div>
        <a href="${pageContext.request.contextPath}/request/create" class="btn btn-blood-danger py-2 px-4">
            <i class="fa-solid fa-plus-circle me-2"></i> Create New Request
        </a>
    </div>

    <!-- Requests Table Card -->
    <div class="glass-card p-4 mb-4">
        <h4 class="text-white mb-4"><i class="fa-solid fa-notes-medical text-danger me-2"></i> My Donation Requests</h4>

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
                                <th>Urgency</th>
                                <th>Status</th>
                                <th>Responses</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${requestsList}">
                                <tr>
                                    <td>
                                        <strong class="text-white"><c:out value="${req.patientName}" /></strong>
                                        <span class="d-block text-secondary small">Created: <c:out value="${req.createdAt}" /></span>
                                    </td>
                                    <td><span class="badge bg-danger"><c:out value="${req.bloodGroup}" /></span></td>
                                    <td><c:out value="${req.unitsNeeded}" /></td>
                                    <td>
                                        <strong class="text-white"><c:out value="${req.hospitalName}" /></strong>
                                        <span class="d-block text-secondary small"><c:out value="${req.city}" />, <c:out value="${req.state}" /></span>
                                    </td>
                                    <td><span class="badge badge-urgency-${req.urgency.toLowerCase()}"><c:out value="${req.urgency}" /></span></td>
                                    <td><span class="badge badge-status-${req.status.toLowerCase()}"><c:out value="${req.status}" /></span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/request/view-responses?requestId=${req.requestId}" class="badge bg-info bg-opacity-20 text-info border border-info text-decoration-none py-2 px-3">
                                            <i class="fa-solid fa-users me-1"></i> <c:out value="${req.responseCount}" /> Donors Responded
                                        </a>
                                    </td>
                                    <td>
                                        <div class="dropdown">
                                            <button class="btn btn-blood-outline btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                                Update Status
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-dark">
                                                <li>
                                                    <form action="${pageContext.request.contextPath}/request/update-status" method="POST">
                                                        <input type="hidden" name="requestId" value="${req.requestId}">
                                                        <input type="hidden" name="status" value="FULFILLED">
                                                        <button type="submit" class="dropdown-item text-success"><i class="fa-solid fa-circle-check me-2"></i>Mark Fulfilled</button>
                                                    </form>
                                                </li>
                                                <li>
                                                    <form action="${pageContext.request.contextPath}/request/update-status" method="POST">
                                                        <input type="hidden" name="requestId" value="${req.requestId}">
                                                        <input type="hidden" name="status" value="CANCELLED">
                                                        <button type="submit" class="dropdown-item text-danger"><i class="fa-solid fa-ban me-2"></i>Cancel Request</button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 text-secondary">
                    <i class="fa-solid fa-folder-open display-4 mb-3 text-secondary"></i>
                    <p class="mb-3">You have not created any blood donation requests yet.</p>
                    <a href="${pageContext.request.contextPath}/request/create" class="btn btn-blood-danger btn-sm">
                        Create Your First Request
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
