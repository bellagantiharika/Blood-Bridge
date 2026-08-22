<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Request Blood - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="glass-card p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="blood-badge mx-auto mb-3">
                        <i class="fa-solid fa-notes-medical"></i>
                    </div>
                    <h3 class="text-white fw-bold">Post Blood Donation Request</h3>
                    <p class="text-secondary small">Notify matching voluntary donors immediately about your hospital need</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger glass-card border-danger text-danger p-3 mb-3 small" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-1"></i> <c:out value="${errorMessage}" />
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/request/create" method="POST" class="needs-validation" novalidate>
                    
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">PATIENT FULL NAME *</label>
                            <input type="text" name="patientName" class="form-control form-control-dark" placeholder="e.g. Michael Smith" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">REQUIRED BLOOD GROUP *</label>
                            <select name="bloodGroup" class="form-select form-select-dark" required>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">UNITS NEEDED *</label>
                            <input type="number" name="unitsNeeded" class="form-control form-control-dark" min="1" max="10" value="1" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">URGENCY LEVEL *</label>
                            <select name="urgency" class="form-select form-select-dark" required>
                                <option value="NORMAL">Normal (Within 48 hours)</option>
                                <option value="URGENT">Urgent (Within 24 hours)</option>
                                <option value="CRITICAL">Critical (Immediate Emergency)</option>
                            </select>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">HOSPITAL NAME *</label>
                            <input type="text" name="hospitalName" class="form-control form-control-dark" placeholder="e.g. City General Hospital" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">CONTACT PHONE *</label>
                            <input type="tel" name="contactPhone" class="form-control form-control-dark" placeholder="9876543210" required>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">CITY *</label>
                            <input type="text" name="city" class="form-control form-control-dark" placeholder="e.g. New York" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">STATE *</label>
                            <input type="text" name="state" class="form-control form-control-dark" placeholder="e.g. NY" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-secondary small fw-bold">HOSPITAL FULL ADDRESS *</label>
                        <textarea name="hospitalAddress" class="form-control form-control-dark" rows="2" placeholder="Full street address of hospital room / blood bank..." required></textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-secondary small fw-bold">ADDITIONAL NOTES / MEDICAL DETAILS</label>
                        <textarea name="note" class="form-control form-control-dark" rows="3" placeholder="Specify surgical cause or specific instructions for donors..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-blood-danger w-100 py-3 font-semibold">
                        Publish Emergency Request <i class="fa-solid fa-paper-plane ms-2"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
