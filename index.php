<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row min-vh-100">
            <div class="col-md-6 d-flex align-items-center justify-content-center bg-primary">
                <div class="text-center text-white">
                    <h1><i class="fas fa-book"></i> Library Management System</h1>
                    <p class="lead">Comprehensive web-based library management with C++ backend support</p>
                </div>
            </div>
            <div class="col-md-6 d-flex align-items-center justify-content-center">
                <div class="card shadow-lg" style="width: 400px;">
                    <div class="card-body">
                        <h2 class="text-center mb-4">Welcome</h2>
                        <div class="d-grid gap-3">
                            <a href="admin/" class="btn btn-primary btn-lg">
                                <i class="fas fa-user-tie"></i> Admin Login
                            </a>
                            <a href="student/" class="btn btn-success btn-lg">
                                <i class="fas fa-user-graduate"></i> Student Portal
                            </a>
                            <a href="#" onclick="runCppSystem()" class="btn btn-info btn-lg">
                                <i class="fas fa-terminal"></i> C++ System
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function runCppSystem() {
            alert('To run the C++ system, execute: ./library_system in the terminal');
        }
    </script>
</body>
</html>
