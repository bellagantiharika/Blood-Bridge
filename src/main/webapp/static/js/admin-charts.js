/**
 * Admin Dashboard Chart.js Integration
 */
document.addEventListener('DOMContentLoaded', () => {
    const bloodChartCtx = document.getElementById('bloodGroupChart');
    const requestChartCtx = document.getElementById('requestStatusChart');

    if (bloodChartCtx || requestChartCtx) {
        fetch(window.contextPath + '/admin/api/stats')
            .then(res => res.json())
            .then(data => {
                // Render Blood Group Bar Chart
                if (bloodChartCtx && data.bloodGroupCounts) {
                    const labels = Object.keys(data.bloodGroupCounts);
                    const values = Object.values(data.bloodGroupCounts);

                    new Chart(bloodChartCtx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Donors Count',
                                data: values,
                                backgroundColor: [
                                    '#e63946', '#f1faee', '#a8dadc', '#457b9d',
                                    '#1d3557', '#ffb703', '#fb8500', '#2a9d8f'
                                ],
                                borderRadius: 8
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: { display: false },
                                title: { display: true, text: 'Donors by Blood Group', color: '#f8fafc' }
                            },
                            scales: {
                                y: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(255,255,255,0.05)' } },
                                x: { ticks: { color: '#94a3b8' }, grid: { display: false } }
                            }
                        }
                    });
                }

                // Render Request Status Doughnut Chart
                if (requestChartCtx && data.requestStats) {
                    const stats = data.requestStats;
                    new Chart(requestChartCtx, {
                        type: 'doughnut',
                        data: {
                            labels: ['Pending', 'Accepted', 'Fulfilled', 'Cancelled'],
                            datasets: [{
                                data: [
                                    stats.PENDING || 0,
                                    stats.ACCEPTED || 0,
                                    stats.FULFILLED || 0,
                                    stats.CANCELLED || 0
                                ],
                                backgroundColor: ['#fbbf24', '#38bdf8', '#34d399', '#94a3b8'],
                                borderWidth: 0
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: { position: 'bottom', labels: { color: '#f8fafc' } },
                                title: { display: true, text: 'Request Status Distribution', color: '#f8fafc' }
                            }
                        }
                    });
                }
            })
            .catch(err => console.error('Failed to load admin stats API:', err));
    }
});
