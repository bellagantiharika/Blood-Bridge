<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Find Blood Donors - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5">
    
    <!-- Search Header & Filter Form -->
    <div class="glass-card p-4 mb-5">
        <h3 class="text-white fw-bold mb-3"><i class="fa-solid fa-magnifying-glass text-danger me-2"></i> Search Voluntary Blood Donors</h3>
        <form action="${pageContext.request.contextPath}/search" method="GET" class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label text-secondary small fw-bold">BLOOD GROUP</label>
                <select name="bloodGroup" class="form-select form-select-dark">
                    <option value="ALL" ${bloodGroup == null || bloodGroup == 'ALL' ? 'selected' : ''}>All Blood Groups</option>
                    <option value="A+" ${bloodGroup == 'A+' ? 'selected' : ''}>A+</option>
                    <option value="A-" ${bloodGroup == 'A-' ? 'selected' : ''}>A-</option>
                    <option value="B+" ${bloodGroup == 'B+' ? 'selected' : ''}>B+</option>
                    <option value="B-" ${bloodGroup == 'B-' ? 'selected' : ''}>B-</option>
                    <option value="AB+" ${bloodGroup == 'AB+' ? 'selected' : ''}>AB+</option>
                    <option value="AB-" ${bloodGroup == 'AB-' ? 'selected' : ''}>AB-</option>
                    <option value="O+" ${bloodGroup == 'O+' ? 'selected' : ''}>O+</option>
                    <option value="O-" ${bloodGroup == 'O-' ? 'selected' : ''}>O- (Universal Donor)</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label text-secondary small fw-bold">CITY</label>
                <input type="text" name="city" class="form-control form-control-dark" placeholder="e.g. New York" value="<c:out value="${city}" />">
            </div>
            <div class="col-md-3">
                <label class="form-label text-secondary small fw-bold">STATE</label>
                <input type="text" name="state" class="form-control form-control-dark" placeholder="e.g. NY" value="<c:out value="${state}" />">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-blood-danger w-100 py-2 font-semibold">
                    Filter Results
                </button>
            </div>
        </form>
    </div>

    <!-- Search Results Section -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="text-white mb-0">Donor Search Results</h4>
        <span class="badge bg-danger fs-6 px-3 py-2"><c:out value="${totalResults}" /> Donors Found</span>
    </div>

    <c:choose>
        <c:when test="${not empty donorsList}">
            <div class="row g-4">
                <c:forEach var="donor" items="${donorsList}">
                    <div class="col-md-6 col-lg-4">
                        <div class="glass-card p-4 h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="blood-badge fs-4" style="width: 50px; height: 50px;">
                                            <c:out value="${donor.bloodGroup}" />
                                        </div>
                                        <div>
                                            <h5 class="text-white mb-0 fw-bold"><c:out value="${donor.user.name}" /></h5>
                                            <span class="text-secondary small"><i class="fa-solid fa-location-dot text-danger me-1"></i> <c:out value="${donor.city}" />, <c:out value="${donor.state}" /></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="row g-2 my-3 p-3 bg-black bg-opacity-20 rounded small">
                                    <div class="col-6">
                                        <span class="text-secondary d-block">Age / Gender:</span>
                                        <strong class="text-white"><c:out value="${donor.age}" /> yrs / <c:out value="${donor.gender}" /></strong>
                                    </div>
                                    <div class="col-6">
                                        <span class="text-secondary d-block">Status:</span>
                                        <c:choose>
                                            <c:when test="${donor.availability}">
                                                <span class="badge bg-success bg-opacity-20 text-success border border-success">Available</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Not Available</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-12 mt-2">
                                        <span class="text-secondary d-block">Last Donation:</span>
                                        <strong class="text-white"><c:out value="${donor.lastDonationDate != null ? donor.lastDonationDate : 'Never Donated'}" /></strong>
                                    </div>
                                </div>
                            </div>

                            <div class="border-top border-secondary border-opacity-20 pt-3">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <div class="d-flex align-items-center justify-content-between">
                                            <span class="text-secondary small"><i class="fa-solid fa-phone me-1 text-danger"></i> <c:out value="${donor.user.phone}" /></span>
                                            <a href="${pageContext.request.contextPath}/request/create" class="btn btn-blood-danger btn-sm">Request Blood</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center">
                                            <span class="text-secondary small d-block mb-2"><i class="fa-solid fa-lock me-1"></i> Contact details masked</span>
                                            <a href="${pageContext.request.contextPath}/login" class="btn btn-blood-outline btn-sm w-100">Log In to View Contact</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="glass-card p-5 text-center text-secondary">
                <i class="fa-solid fa-user-slash display-3 mb-3 text-secondary"></i>
                <h4 class="text-white">No Donors Found</h4>
                <p class="mb-0">Try broadening your search criteria or searching for universal donor O-.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
