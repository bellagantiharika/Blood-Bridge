<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Admin Panel - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
        <div>
            <h2 class="text-white fw-bold mb-1"><i class="fa-solid fa-shield-halved text-danger me-2"></i> Platform Administration Dashboard</h2>
            <p class="text-secondary small mb-0">Overview of platform metrics, user access management, and request monitoring</p>
        </div>
    </div>

    <!-- Stat KPI Cards -->
    <div class="row g-4 mb-5">
        <div class="col-md-3 col-6">
            <div class="glass-card p-4 text-center">
                <i class="fa-solid fa-users display-6 text-primary mb-2"></i>
                <h3 class="text-white fw-extrabold mb-1"><c:out value="${totalUsers}" /></h3>
                <span class="text-secondary small text-uppercase fw-bold">Total Platform Users</span>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="glass-card p-4 text-center">
                <i class="fa-solid fa-droplet display-6 text-danger mb-2"></i>
                <h3 class="text-white fw-extrabold mb-1"><c:out value="${totalDonors}" /></h3>
                <span class="text-secondary small text-uppercase fw-bold">Active Donors</span>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="glass-card p-4 text-center">
                <i class="fa-solid fa-file-medical display-6 text-warning mb-2"></i>
                <h3 class="text-white fw-extrabold mb-1"><c:out value="${requestStats['TOTAL']}" /></h3>
                <span class="text-secondary small text-uppercase fw-bold">Total Requests</span>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="glass-card p-4 text-center">
                <i class="fa-solid fa-circle-check display-6 text-success mb-2"></i>
                <h3 class="text-white fw-extrabold mb-1"><c:out value="${requestStats['FULFILLED']}" /></h3>
                <span class="text-secondary small text-uppercase fw-bold">Fulfilled Requests</span>
            </div>
        </div>
    </div>

    <!-- Chart.js Analytics Grid -->
    <div class="row g-4 mb-5">
        <div class="col-lg-7">
            <div class="glass-card p-4 h-100">
                <h5 class="text-white fw-bold mb-3"><i class="fa-solid fa-chart-column text-danger me-2"></i> Donor Distribution by Blood Group</h5>
                <div style="position: relative; height: 280px;">
                    <canvas id="bloodGroupChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="glass-card p-4 h-100">
                <h5 class="text-white fw-bold mb-3"><i class="fa-solid fa-chart-pie text-info me-2"></i> Donation Request Breakdown</h5>
                <div style="position: relative; height: 280px;">
                    <canvas id="requestStatusChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- User Management Table -->
    <div class="glass-card p-4 mb-5">
        <h4 class="text-white mb-4"><i class="fa-solid fa-user-gear text-primary me-2"></i> User Account Control</h4>
        <div class="table-responsive">
            <table class="table table-dark-custom align-middle">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Joined Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${allUsers}">
                        <tr>
                            <td>#<c:out value="${u.userId}" /></td>
                            <td><strong class="text-white"><c:out value="${u.name}" /></strong></td>
                            <td><c:out value="${u.email}" /></td>
                            <td><c:out value="${u.phone}" /></td>
                            <td>
                                <span class="badge ${u.role == 'ADMIN' ? 'bg-danger' : (u.role == 'DONOR' ? 'bg-info' : 'bg-secondary')}">
                                    <c:out value="${u.role}" />
                                </span>
                            </td>
                            <td>
                                <span class="badge ${u.status == 'ACTIVE' ? 'bg-success' : 'bg-warning'}"><c:out value="${u.status}" /></span>
                            </td>
                            <td class="text-secondary small"><c:out value="${u.createdAt}" /></td>
                            <td>
                                <c:if test="${!u.isAdmin()}">
                                    <div class="d-flex gap-2">
                                        <form action="${pageContext.request.contextPath}/admin/users/status" method="POST">
                                            <input type="hidden" name="userId" value="${u.userId}">
                                            <input type="hidden" name="status" value="${u.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'}">
                                            <button type="submit" class="btn btn-sm ${u.status == 'ACTIVE' ? 'btn-outline-warning' : 'btn-outline-success'}">
                                                <c:out value="${u.status == 'ACTIVE' ? 'Deactivate' : 'Activate'}" />
                                            </button>
                                        </form>

                                        <form action="${pageContext.request.contextPath}/admin/users/delete" method="POST" onsubmit="return confirm('Are you sure you want to delete this user?');">
                                            <input type="hidden" name="userId" value="${u.userId}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm"><i class="fa-solid fa-trash"></i></button>
                                        </form>
                                    </div>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Request Moderation Table -->
    <div class="glass-card p-4">
        <h4 class="text-white mb-4"><i class="fa-solid fa-list-check text-warning me-2"></i> All Platform Blood Requests</h4>
        <div class="table-responsive">
            <table class="table table-dark-custom align-middle">
                <thead>
                    <tr>
                        <th>Req ID</th>
                        <th>Patient</th>
                        <th>Blood Group</th>
                        <th>Hospital & Location</th>
                        <th>Urgency</th>
                        <th>Status</th>
                        <th>Moderate Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="req" items="${allRequests}">
                        <tr>
                            <td>#<c:out value="${req.requestId}" /></td>
                            <td><strong class="text-white"><c:out value="${req.patientName}" /></strong></td>
                            <td><span class="badge bg-danger"><c:out value="${req.bloodGroup}" /></span></td>
                            <td><c:out value="${req.hospitalName}" /> (<c:out value="${req.city}" />)</td>
                            <td><span class="badge badge-urgency-${req.urgency.toLowerCase()}"><c:out value="${req.urgency}" /></span></td>
                            <td><span class="badge badge-status-${req.status.toLowerCase()}"><c:out value="${req.status}" /></span></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/requests/status" method="POST" class="d-flex gap-2">
                                    <input type="hidden" name="requestId" value="${req.requestId}">
                                    <select name="status" class="form-select form-select-dark form-select-sm" style="width: 140px;">
                                        <option value="PENDING" ${req.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                        <option value="ACCEPTED" ${req.status == 'ACCEPTED' ? 'selected' : ''}>ACCEPTED</option>
                                        <option value="FULFILLED" ${req.status == 'FULFILLED' ? 'selected' : ''}>FULFILLED</option>
                                        <option value="CANCELLED" ${req.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                    </select>
                                    <button type="submit" class="btn btn-blood-danger btn-sm">Update</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Admin Chart JS Script -->
<script src="${pageContext.request.contextPath}/static/js/admin-charts.js"></script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
