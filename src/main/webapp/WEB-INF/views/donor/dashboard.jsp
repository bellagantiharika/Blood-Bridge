<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Donor Dashboard - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5">
    
    <!-- Donor Profile Overview -->
    <div class="row g-4 mb-5">
        <div class="col-lg-8">
            <div class="glass-card p-4 h-100 d-flex flex-column justify-content-between">
                <div>
                    <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                        <div class="d-flex align-items-center gap-3">
                            <div class="blood-badge fs-4" style="width: 56px; height: 56px;">
                                <c:out value="${donor.bloodGroup}" />
                            </div>
                            <div>
                                <h3 class="text-white mb-0 fw-bold"><c:out value="${donor.user.name}" /></h3>
                                <span class="text-secondary small"><i class="fa-solid fa-envelope me-1"></i> <c:out value="${donor.user.email}" /> | <i class="fa-solid fa-phone me-1"></i> <c:out value="${donor.user.phone}" /></span>
                            </div>
                        </div>

                        <!-- Availability Status Badge + Toggle -->
                        <form action="${pageContext.request.contextPath}/donor/toggle-availability" method="POST">
                            <button type="submit" class="btn ${donor.availability ? 'btn-success' : 'btn-outline-secondary'} btn-sm px-3 py-2 rounded-pill fw-bold">
                                <i class="fa-solid ${donor.availability ? 'fa-toggle-on' : 'fa-toggle-off'} me-1"></i>
                                Status: <c:out value="${donor.availability ? 'AVAILABLE' : 'NOT AVAILABLE'}" />
                            </button>
                        </form>
                    </div>

                    <div class="row g-3 mt-2">
                        <div class="col-6 col-sm-3">
                            <span class="text-secondary small d-block">LOCATION</span>
                            <strong class="text-white"><c:out value="${donor.city}" />, <c:out value="${donor.state}" /></strong>
                        </div>
                        <div class="col-6 col-sm-3">
                            <span class="text-secondary small d-block">AGE / GENDER</span>
                            <strong class="text-white"><c:out value="${donor.age}" /> yrs / <c:out value="${donor.gender}" /></strong>
                        </div>
                        <div class="col-6 col-sm-3">
                            <span class="text-secondary small d-block">LAST DONATED</span>
                            <strong class="text-white">
                                <c:choose>
                                    <c:when test="${donor.lastDonationDate != null}">
                                        <c:out value="${donor.lastDonationDate}" />
                                    </c:when>
                                    <c:otherwise>Never</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                        <div class="col-6 col-sm-3">
                            <span class="text-secondary small d-block">ELIGIBILITY</span>
                            <c:choose>
                                <c:when test="${donor.eligibleToDonate}">
                                    <span class="badge bg-success bg-opacity-20 text-success border border-success px-2 py-1">Eligible to Donate</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning bg-opacity-20 text-warning border border-warning px-2 py-1">Wait ${donor.daysUntilNextDonation} Days</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Update Last Donation Date Form -->
                <div class="border-top border-secondary border-opacity-20 pt-3 mt-4">
                    <form action="${pageContext.request.contextPath}/donor/update-last-donation" method="POST" class="row g-2 align-items-center">
                        <div class="col-auto">
                            <label class="text-secondary small fw-bold">Update Last Donation Date:</label>
                        </div>
                        <div class="col-auto">
                            <input type="date" name="lastDonationDate" class="form-control form-control-dark form-control-sm" required>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-blood-danger btn-sm">Update Date</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Donor Eligibility Card -->
        <div class="col-lg-4">
            <div class="glass-card p-4 h-100 text-center d-flex flex-direction-column justify-content-center">
                <div class="my-auto">
                    <i class="fa-solid fa-heart-pulse text-danger display-3 mb-3"></i>
                    <h4 class="text-white font-bold">Donation Eligibility</h4>
                    <p class="text-secondary small mb-3">
                        Medical guidelines recommend a minimum 90-day recovery interval between whole blood donations.
                    </p>
                    <c:choose>
                        <c:when test="${donor.eligibleToDonate}">
                            <div class="alert alert-success glass-card border-success text-success p-3 mb-0">
                                <i class="fa-solid fa-circle-check me-1"></i> You are fully eligible to donate blood today!
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning glass-card border-warning text-warning p-3 mb-0">
                                <i class="fa-solid fa-clock me-1"></i> Please wait <strong>${donor.daysUntilNextDonation} more days</strong> before your next donation.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Matching Blood Requests Section -->
    <div class="glass-card p-4 mb-5">
        <h4 class="text-white mb-4 d-flex align-items-center justify-content-between">
            <span><i class="fa-solid fa-hand-holding-medical text-danger me-2"></i> Matching Emergency Blood Requests</span>
            <span class="badge bg-danger fs-6">${matchingRequests.size()} Requests Found</span>
        </h4>

        <c:choose>
            <c:when test="${not empty matchingRequests}">
                <div class="table-responsive">
                    <table class="table table-dark-custom align-middle">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Blood Group</th>
                                <th>Units</th>
                                <th>Hospital & Location</th>
                                <th>Urgency</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${matchingRequests}">
                                <tr>
                                    <td>
                                        <strong class="text-white"><c:out value="${req.patientName}" /></strong>
                                        <span class="d-block text-secondary small">Req ID: #${req.requestId}</span>
                                    </td>
                                    <td>
                                        <span class="badge bg-danger"><c:out value="${req.bloodGroup}" /></span>
                                    </td>
                                    <td><c:out value="${req.unitsNeeded}" /> Unit(s)</td>
                                    <td>
                                        <strong class="text-white"><c:out value="${req.hospitalName}" /></strong>
                                        <span class="d-block text-secondary small"><c:out value="${req.city}" />, <c:out value="${req.state}" /></span>
                                    </td>
                                    <td>
                                        <span class="badge badge-urgency-${req.urgency.toLowerCase()}"><c:out value="${req.urgency}" /></span>
                                    </td>
                                    <td>
                                        <!-- Respond Button Triggering Modal -->
                                        <button class="btn btn-blood-danger btn-sm" data-bs-toggle="modal" data-bs-target="#respondModal${req.requestId}">
                                            <i class="fa-solid fa-reply me-1"></i> Respond
                                        </button>

                                        <!-- Response Modal -->
                                        <div class="modal fade" id="respondModal${req.requestId}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content glass-card border-secondary text-white">
                                                    <div class="modal-header border-secondary">
                                                        <h5 class="modal-title"><i class="fa-solid fa-heart-pulse text-danger me-2"></i> Respond to Blood Request</h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <form action="${pageContext.request.contextPath}/request/respond" method="POST">
                                                        <div class="modal-body">
                                                            <input type="hidden" name="requestId" value="${req.requestId}">
                                                            <p class="text-secondary small">
                                                                Responding to request for <strong><c:out value="${req.patientName}" /></strong> at <strong><c:out value="${req.hospitalName}" /></strong>.
                                                            </p>
                                                            <div class="mb-3">
                                                                <label class="form-label text-secondary small">Message / Availability Note (Optional)</label>
                                                                <textarea name="message" class="form-control form-control-dark" rows="3" placeholder="e.g. I can reach the hospital by 10 AM tomorrow..."></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer border-secondary">
                                                            <button type="button" class="btn btn-blood-outline btn-sm" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-blood-danger btn-sm">Submit Response</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-4 text-secondary">
                    <i class="fa-solid fa-circle-check display-4 mb-2 text-success"></i>
                    <p class="mb-0">No active emergency requests for blood group <strong><c:out value="${donor.bloodGroup}" /></strong> at this moment.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- My Response History -->
    <div class="glass-card p-4">
        <h4 class="text-white mb-4"><i class="fa-solid fa-clock-rotate-left text-info me-2"></i> My Response History</h4>
        <c:choose>
            <c:when test="${not empty myResponses}">
                <div class="table-responsive">
                    <table class="table table-dark-custom align-middle">
                        <thead>
                            <tr>
                                <th>Request Patient</th>
                                <th>Hospital</th>
                                <th>My Message</th>
                                <th>Response Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="res" items="${myResponses}">
                                <tr>
                                    <td><strong class="text-white"><c:out value="${res.bloodRequest.patientName}" /></strong></td>
                                    <td><c:out value="${res.bloodRequest.hospitalName}" /> (<c:out value="${res.bloodRequest.city}" />)</td>
                                    <td class="text-secondary small"><c:out value="${res.message}" /></td>
                                    <td class="text-secondary small"><c:out value="${res.respondedAt}" /></td>
                                    <td>
                                        <span class="badge badge-status-${res.status.toLowerCase()}"><c:out value="${res.status}" /></span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <p class="text-secondary mb-0">You haven't responded to any donation requests yet.</p>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
