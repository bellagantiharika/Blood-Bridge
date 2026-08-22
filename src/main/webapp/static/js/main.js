/**
 * BloodBridge Main Client-side Scripting
 */
document.addEventListener('DOMContentLoaded', () => {
    
    // Auto dismiss alert toasts
    const alertElements = document.querySelectorAll('.alert-dismissible');
    alertElements.forEach(alert => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) bsAlert.close();
        }, 5000);
    });

    // Registration Form Role Field Dynamic Toggle
    const roleSelect = document.getElementById('roleSelect');
    const donorFields = document.getElementById('donorFields');
    const locationFields = document.getElementById('locationFields');
    const bloodGroupSelect = document.getElementById('bloodGroupSelect');
    const ageInput = document.getElementById('ageInput');
    const genderSelect = document.getElementById('genderSelect');

    if (roleSelect) {
        function toggleRoleFields() {
            const val = roleSelect.value;
            if (val === 'DONOR') {
                if (donorFields) donorFields.style.display = 'block';
                if (bloodGroupSelect) bloodGroupSelect.required = true;
                if (ageInput) ageInput.required = true;
                if (genderSelect) genderSelect.required = true;
            } else {
                if (donorFields) donorFields.style.display = 'none';
                if (bloodGroupSelect) bloodGroupSelect.required = false;
                if (ageInput) ageInput.required = false;
                if (genderSelect) genderSelect.required = false;
            }
            if (locationFields) locationFields.style.display = 'block';
        }
        roleSelect.addEventListener('change', toggleRoleFields);
        toggleRoleFields(); // Initialize on page load
    }

    // Client-side Form Validation
    const forms = document.querySelectorAll('.needs-validation');
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
});
