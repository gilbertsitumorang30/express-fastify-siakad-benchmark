$vusList = @(10, 50, 100, 250, 500, 1000)

foreach ($vus in $vusList) {

    Write-Host ""
    Write-Host "======================================="
    Write-Host "FASTIFY GRADES TEST - $vus VUs"
    Write-Host "======================================="

    k6 run `
        -e VUS=$vus `
        -e DURATION=30s `
        .\grades_test.js `
        --summary-export=.\results\grades_$($vus)_summary.json

    Write-Host ""
    Write-Host "======================================="
    Write-Host "FASTIFY REGISTRATION TEST - $vus VUs"
    Write-Host "======================================="

    k6 run `
        -e VUS=$vus `
        -e DURATION=30s `
        .\registration_test.js `
        --summary-export=.\results\registration_$($vus)_summary.json
}