document.addEventListener('DOMContentLoaded', () => {
    const reportButtons = document.querySelectorAll('.btn-report');
    const timeFilter = document.getElementById('time-filter');
    const statusFilter = document.getElementById('status-filter');
    const reportResults = document.getElementById('report-results');

    // This function will set up event listeners for the print and download buttons
    const initializeReportControls = () => {
        const printButton = document.getElementById('print-button');
        const downloadButton = document.getElementById('download-button');
        
        // This check is now necessary inside the function
        if (printButton && downloadButton) {
            printButton.addEventListener('click', () => {
                window.print();
            });
            downloadButton.addEventListener('click', () => {
                const reportContent = document.getElementById('report-content');
                
                html2canvas(reportContent).then(canvas => {
                    const { jsPDF } = window.jspdf;
                    const imgData = canvas.toDataURL('image/png');
                    const pdf = new jsPDF('p', 'mm', 'a4');
                    const imgWidth = 210;
                    const pageHeight = 295;
                    const imgHeight = canvas.height * imgWidth / canvas.width;
                    let heightLeft = imgHeight;
                    let position = 0;

                    pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
                    heightLeft -= pageHeight;

                    while (heightLeft >= 0) {
                        position = heightLeft - imgHeight;
                        pdf.addPage();
                        pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
                        heightLeft -= pageHeight;
                    }
                    pdf.save('report.pdf');
                });
            });
        }
    };

    // Add click listeners to report generation buttons
    reportButtons.forEach(button => {
        button.addEventListener('click', () => {
            const reportType = button.dataset.reportType;
            const selectedTimeFilter = timeFilter.value;
            const selectedStatusFilter = statusFilter.value;
            const url = `${window.location.origin}/ems/admin/reports/generate?type=${reportType}&time=${selectedTimeFilter}&status=${selectedStatusFilter}`;

            reportResults.innerHTML = `
                <div class="flex flex-col items-center justify-center h-full text-gray-500">
                    <i class="fas fa-spinner fa-spin text-5xl mb-3 text-gray-300"></i>
                    <p class="text-center text-lg font-medium">Generating ${reportType.replace('_', ' ')} report...</p>
                </div>
            `;

            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        return response.text().then(text => { throw new Error(text) });
                    }
                    return response.text();
                })
                .then(html => {
                    // Inject the received HTML
                    reportResults.innerHTML = html;
                    
                    // Now that the new HTML is on the page, initialize the buttons
                    initializeReportControls();
                })
                .catch(error => {
                    console.error('Error generating report:', error);
                    reportResults.innerHTML = `
                        <div class="flex flex-col items-center justify-center h-full text-gray-500">
                            <i class="fas fa-exclamation-triangle text-5xl mb-3 text-red-500"></i>
                            <p class="text-center text-lg font-medium text-red-500">Error generating report.</p>
                            <p class="text-center text-sm mt-2">${error.message}</p>
                        </div>
                    `;
                });
        });
    });

    // Also call it once on initial page load in case a report is already loaded
    initializeReportControls();
});
