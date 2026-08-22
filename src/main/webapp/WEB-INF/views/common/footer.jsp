<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="footer-blood">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="text-white mb-3 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-droplet text-danger"></i> BloodBridge
                </h5>
                <p class="small text-secondary">
                    BloodBridge is a non-profit digital initiative connecting voluntary blood donors directly with recipients and healthcare providers to eliminate emergency supply delays.
                </p>
            </div>
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white mb-3">Quick Links</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none">Home</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/search" class="text-secondary text-decoration-none">Search Donors</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/request/list" class="text-secondary text-decoration-none">Active Requests</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/register" class="text-secondary text-decoration-none">Register as Donor</a></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Emergency Support</h6>
                <p class="small text-secondary mb-1"><i class="fa-solid fa-phone me-2 text-danger"></i> 24/7 Helpline: 1800-BLOOD-BRIDGE</p>
                <p class="small text-secondary mb-1"><i class="fa-solid fa-envelope me-2 text-danger"></i> support@bloodbridge.org</p>
                <p class="small text-secondary"><i class="fa-solid fa-location-dot me-2 text-danger"></i> Medical Emergency Hub, NY 10001</p>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Blood Group Matrix</h6>
                <div class="d-flex flex-wrap gap-2">
                    <span class="badge bg-danger">A+</span>
                    <span class="badge bg-danger">A-</span>
                    <span class="badge bg-danger">B+</span>
                    <span class="badge bg-danger">B-</span>
                    <span class="badge bg-danger">O+</span>
                    <span class="badge bg-danger">O-</span>
                    <span class="badge bg-danger">AB+</span>
                    <span class="badge bg-danger">AB-</span>
                </div>
            </div>
        </div>
        <hr class="my-4 border-secondary opacity-25">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small text-secondary">
            <p class="mb-0">&copy; 2026 BloodBridge Platform. All rights reserved.</p>
            <p class="mb-0">Built with Java Servlets, JSP & Bootstrap 5</p>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 Bundle JS (Includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- BloodBridge Custom Script -->
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

</body>
</html>
