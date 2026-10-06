<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="BloodBridge - Home" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<!-- Hero Section -->
<section class="hero-section text-center text-lg-start">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-7">
                   <div class="badge bg-danger bg-opacity-20 text-white border border-danger px-3 py-2 rounded-pill mb-3">
                 <i class="fa-solid fa-heart-pulse me-1 text-danger"></i> Every Drop Saves a Life
                </div>
                <h1 class="hero-title mb-4">
                    Connecting <span>Blood Donors</span> with Emergency Patients Instantly.
                </h1>
                <p class="lead text-secondary mb-4 fs-5">
                   BloodBridge is a real-time voluntary blood donation platform. Search donors by location and blood group, send urgent donation requests directly to verified donors, and save lives today.
                </p>
                <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-blood-danger btn-lg px-4 fs-6">
                        <i class="fa-solid fa-magnifying-glass me-2"></i> Find Donors Now
                    </a>
                    <a href="${pageContext.request.contextPath}/request/create" class="btn btn-blood-outline btn-lg px-4 fs-6">
                        <i class="fa-solid fa-plus-circle me-2"></i> Request Blood
                    </a>
                </div>
            </div>
            <div class="col-lg-5">
                <!-- Search Quick Widget -->
                <div class="glass-card p-4 p-md-5">
                    <h4 class="text-white mb-3 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-filter text-danger"></i> Quick Donor Search
                    </h4>
                    <form action="${pageContext.request.contextPath}/search" method="GET">
                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">SELECT BLOOD GROUP</label>
                            <select name="bloodGroup" class="form-select form-select-dark">
                                <option value="ALL">All Blood Groups</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O- (Universal Donor)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">CITY / LOCATION</label>
                            <input type="text" name="city" class="form-control form-control-dark" placeholder="e.g. New York, Chicago">
                        </div>
                        <button type="submit" class="btn btn-blood-danger w-100 py-3 mt-2 fw-bold">
                            <i class="fa-solid fa-search me-2"></i> Search Donors
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Impact Metrics Counter -->
<section class="py-5 bg-black bg-opacity-30 border-top border-bottom border-secondary border-opacity-20">
    <div class="container">
        <div class="row g-4 text-center">
            <div class="col-6 col-md-3">
                <h2 class="display-5 fw-extrabold text-danger mb-1">5,000+</h2>
                <p class="text-secondary small text-uppercase tracking-wider mb-0">Registered Donors</p>
            </div>
            <div class="col-6 col-md-3">
                <h2 class="display-5 fw-extrabold text-info mb-1">1,200+</h2>
                <p class="text-secondary small text-uppercase tracking-wider mb-0">Successful Requests</p>
            </div>
            <div class="col-6 col-md-3">
                <h2 class="display-5 fw-extrabold text-warning mb-1">98%</h2>
                <p class="text-secondary small text-uppercase tracking-wider mb-0">Fulfillment Rate</p>
            </div>
            <div class="col-6 col-md-3">
                <h2 class="display-5 fw-extrabold text-success mb-1">&lt; 15 mins</h2>
                <p class="text-secondary small text-uppercase tracking-wider mb-0">Avg Response Time</p>
            </div>
        </div>
    </div>
</section>

<!-- Features Grid -->
<section class="py-5">
    <div class="container">
        <div class="text-center max-w-2xl mx-auto mb-5">
            <h2 class="text-white fw-bold display-6 mb-3">Why Choose BloodBridge?</h2>
            <p class="text-secondary">Designed to solve emergency blood shortages with seamless technology.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="glass-card p-4 h-100">
                    <div class="rounded-circle bg-danger bg-opacity-20 p-3 d-inline-flex mb-3 text-danger">
                        <i class="fa-solid fa-bolt-lightning fs-3"></i>
                    </div>
                    <h4 class="text-white mb-2">Real-Time Search</h4>
                    <p class="text-secondary small">Instantly query active donors in your specific city and filter by exact blood group compatibility.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card p-4 h-100">
                    <div class="rounded-circle bg-info bg-opacity-20 p-3 d-inline-flex mb-3 text-info">
                        <i class="fa-solid fa-shield-check fs-3"></i>
                    </div>
                    <h4 class="text-white mb-2">Verified Profiles</h4>
                    <p class="text-secondary small">Donors manage their last donation dates and toggle active availability so you only contact ready donors.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card p-4 h-100">
                    <div class="rounded-circle bg-warning bg-opacity-20 p-3 d-inline-flex mb-3 text-warning">
                        <i class="fa-solid fa-hospital-user fs-3"></i>
                    </div>
                    <h4 class="text-white mb-2">Direct Patient Requests</h4>
                    <p class="text-secondary small">Hospitals and recipients issue emergency requests with detailed urgency indicators and unit counts.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
