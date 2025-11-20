const { createApp } = Vue;

createApp({
    data() {
        return {
            patientData: {
                age: 45,
                blood_pressure: 130,
                cholesterol: 200,
                glucose: 110,
                bmi: 28.5,
                heart_rate: 75
            },
            result: null,
            error: null,
            loading: false,
            // Use empty string for Docker (nginx proxy), or localhost for development
            apiUrl: window.location.hostname === 'localhost' && window.location.port === '3000'
                ? 'http://localhost:8000'
                : ''
        }
    },
    methods: {
        async predictDisease() {
            this.loading = true;
            this.error = null;
            this.result = null;

            try {
                const response = await axios.post(`${this.apiUrl}/api/predict`, this.patientData);

                if (response.data.success) {
                    this.result = response.data.data;
                    this.$nextTick(() => {
                        this.renderChart();
                    });
                } else {
                    this.error = 'Tahlilda xatolik yuz berdi';
                }
            } catch (err) {
                this.error = 'Serverga ulanishda xatolik: ' + (err.message || 'Noma\'lum xatolik');
                console.error('Error:', err);
            } finally {
                this.loading = false;
            }
        },

        getPredictionClass(prediction) {
            return prediction === "Sog'lom" ? 'healthy' : 'warning';
        },

        renderChart() {
            const ctx = document.getElementById('chartCanvas');
            if (!ctx) return;

            // Destroy previous chart if exists
            if (this.chart) {
                this.chart.destroy();
            }

            const diseases = Object.keys(this.result.all_probabilities);
            const probabilities = Object.values(this.result.all_probabilities);

            this.chart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: diseases,
                    datasets: [{
                        label: 'Ehtimollik (%)',
                        data: probabilities,
                        backgroundColor: [
                            'rgba(102, 126, 234, 0.8)',
                            'rgba(118, 75, 162, 0.8)',
                            'rgba(255, 99, 132, 0.8)',
                            'rgba(255, 206, 86, 0.8)',
                            'rgba(75, 192, 192, 0.8)'
                        ],
                        borderColor: [
                            'rgba(102, 126, 234, 1)',
                            'rgba(118, 75, 162, 1)',
                            'rgba(255, 99, 132, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)'
                        ],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100,
                            ticks: {
                                callback: function(value) {
                                    return value + '%';
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        title: {
                            display: true,
                            text: 'Kasalliklar Ehtimolligi',
                            font: {
                                size: 16
                            }
                        }
                    }
                }
            });
        }
    }
}).mount('#app');
