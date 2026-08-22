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
    const recipientFields = document.getElementById('recipientFields');

    if (roleSelect) {
        function toggleRoleFields() {
            const val = roleSelect.value;
            if (val === 'DONOR') {
                if (donorFields) donorFields.style.display = 'block';
                if (recipientFields) recipientFields.style.display = 'block';
            } else if (val === 'RECIPIENT') {
                if (donorFields) donorFields.style.display = 'none';
                if (recipientFields) recipientFields.style.display = 'block';
            }
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
