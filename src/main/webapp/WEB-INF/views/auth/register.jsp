<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Register - BloodBridge" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="glass-card p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="blood-badge mx-auto mb-3">
                        <i class="fa-solid fa-user-plus"></i>
                    </div>
                    <h3 class="fw-bold brand-heading">Create an Account</h3>
                    <p class="text-secondary small">Join BloodBridge as a voluntary Donor or Recipient</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger glass-card border-danger text-danger p-3 mb-3 small" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-1"></i> <c:out value="${errorMessage}" />
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="POST" class="needs-validation" novalidate>
                    
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">FULL NAME *</label>
                            <input type="text" name="name" class="form-control form-control-dark" placeholder="John Doe" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">EMAIL ADDRESS *</label>
                            <input type="email" name="email" class="form-control form-control-dark" placeholder="john@example.com" required>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">PASSWORD *</label>
                            <input type="password" name="password" class="form-control form-control-dark" placeholder="Min 6 characters" minlength="6" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary small fw-bold">PHONE NUMBER *</label>
                            <input type="tel" name="phone" class="form-control form-control-dark" placeholder="9876543210" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-secondary small fw-bold">I WANT TO REGISTER AS *</label>
                        <select name="role" id="roleSelect" class="form-select form-select-dark" required>
                            <option value="DONOR" selected>Blood Donor (Ready to donate blood)</option>
                            <option value="RECIPIENT">Recipient / Patient / Hospital Representative</option>
                        </select>
                    </div>

                    <!-- Donor Specific Fields -->
                    <div id="donorFields" class="border-top border-secondary border-opacity-20 pt-4 mb-4">
                        <h5 class="text-danger mb-3"><i class="fa-solid fa-droplet me-2"></i> Donor Details</h5>
                        <div class="row g-3 mb-3">
                            <div class="col-md-4">
                                <label class="form-label text-secondary small fw-bold">BLOOD GROUP *</label>
                                <select name="bloodGroup" id="bloodGroupSelect" class="form-select form-select-dark" required>
                                    <option value="" disabled selected>Select Blood Group</option>
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
                            <div class="col-md-4">
                                <label class="form-label text-secondary small fw-bold">AGE *</label>
                                <input type="number" name="age" id="ageInput" class="form-control form-control-dark" min="18" max="65" value="25" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-secondary small fw-bold">GENDER *</label>
                                <select name="gender" id="genderSelect" class="form-select form-select-dark" required>
                                    <option value="" disabled selected>Select Gender</option>
                                    <option value="MALE">Male</option>
                                    <option value="FEMALE">Female</option>
                                    <option value="OTHER">Other</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">LAST DONATION DATE (Optional)</label>
                            <input type="date" name="lastDonationDate" class="form-control form-control-dark">
                        </div>
                    </div>

                    <!-- Address & Location Fields (Required for all roles) -->
                    <div id="locationFields" class="border-top border-secondary border-opacity-20 pt-4 mb-4">
                        <h5 class="text-info mb-3"><i class="fa-solid fa-location-dot me-2"></i> Location & Address</h5>
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
                            <label class="form-label text-secondary small fw-bold">FULL ADDRESS *</label>
                            <textarea name="address" class="form-control form-control-dark" rows="2" placeholder="Street address..." required></textarea>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-blood-danger w-100 py-3 font-semibold mb-3">
                        Complete Registration <i class="fa-solid fa-check-circle ms-2"></i>
                    </button>

                    <div class="text-center">
                        <p class="text-secondary small mb-0">
                            Already registered? <a href="${pageContext.request.contextPath}/login" class="text-danger text-decoration-none fw-bold">Log In</a>
                        </p>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
