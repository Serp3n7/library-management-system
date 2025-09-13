<?php
session_start();
include '../config/database.php';

if (!isset($_SESSION['admin_id'])) {
    header('Location: index.php');
    exit();
}

// Get statistics
$stats = [];

// Books count
$stmt = $pdo->query("SELECT COUNT(*) as count FROM books");
$stats['books'] = $stmt->fetch()['count'];

// Students count
$stmt = $pdo->query("SELECT COUNT(*) as count FROM students");
$stats['students'] = $stmt->fetch()['count'];

// Issued books count
$stmt = $pdo->query("SELECT COUNT(*) as count FROM issued_books WHERE status = 'issued'");
$stats['issued'] = $stmt->fetch()['count'];

// Returned books count
$stmt = $pdo->query("SELECT COUNT(*) as count FROM issued_books WHERE status = 'returned'");
$stats['returned'] = $stmt->fetch()['count'];

// Authors count
$stmt = $pdo->query("SELECT COUNT(*) as count FROM authors");
$stats['authors'] = $stmt->fetch()['count'];

// Categories count
$stmt = $pdo->query("SELECT COUNT(*) as count FROM categories");
$stats['categories'] = $stmt->fetch()['count'];
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Library Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../assets/css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-book me-2"></i>
                Online Library Management System
            </a>
            <div class="navbar-nav ms-auto">
                <a href="logout.php" class="btn btn-outline-light">
                    <i class="fas fa-sign-out-alt me-1"></i> Log Out
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-2 d-none d-md-block sidebar">
                <div class="position-sticky">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="dashboard.php">
                                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="categories/">
                                <i class="fas fa-list me-2"></i> Categories
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="authors/">
                                <i class="fas fa-user-edit me-2"></i> Authors
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="books/">
                                <i class="fas fa-book me-2"></i> Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="issue-books/">
                                <i class="fas fa-book-open me-2"></i> Issue Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="students/">
                                <i class="fas fa-users me-2"></i> Students
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="profile/">
                                <i class="fas fa-user-cog me-2"></i> Profile
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">My Profile</h1>
                </div>

                <?php if ($success): ?>
                    <div class="alert alert-success alert-dismissible fade show">
                        <?php echo $success; ?>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <?php endif; ?>

                <?php if ($error): ?>
                    <div class="alert alert-danger alert-dismissible fade show">
                        <?php echo $error; ?>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <?php endif; ?>

                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h5>Profile Information</h5>
                            </div>
                            <div class="card-body">
                                <form method="POST" action="">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="student_id" class="form-label">Student ID</label>
                                            <input type="text" class="form-control" id="student_id" 
                                                   value="<?php echo htmlspecialchars($student['student_id']); ?>" disabled>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="email" class="form-label">Email Address</label>
                                            <input type="email" class="form-control" id="email" 
                                                   value="<?php echo htmlspecialchars($student['email']); ?>" disabled>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="fullname" class="form-label">Full Name *</label>
                                        <input type="text" class="form-control" id="fullname" name="fullname" 
                                               value="<?php echo htmlspecialchars($student['fullname']); ?>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="mobile" class="form-label">Mobile Number</label>
                                        <input type="tel" class="form-control" id="mobile" name="mobile" 
                                               value="<?php echo htmlspecialchars($student['mobile']); ?>">
                                    </div>

                                    <div class="mb-3">
                                        <label for="reg_date" class="form-label">Registration Date</label>
                                        <input type="text" class="form-control" id="reg_date" 
                                               value="<?php echo date('M d, Y', strtotime($student['created_at'])); ?>" disabled>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="submit" class="btn btn-primary">Update Profile</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h5>Account Status</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="fas fa-user-circle fa-2x text-primary me-3"></i>
                                    <div>
                                        <h6 class="mb-0"><?php echo htmlspecialchars($student['fullname']); ?></h6>
                                        <small class="text-muted">Student ID: <?php echo htmlspecialchars($student['student_id']); ?></small>
                                    </div>
                                </div>
                                
                                <hr>
                                
                                <div class="mb-2">
                                    <small class="text-muted">Account Status:</small>
                                    <span class="badge <?php echo $student['status'] ? 'bg-success' : 'bg-danger'; ?> float-end">
                                        <?php echo $student['status'] ? 'Active' : 'Inactive'; ?>
                                    </span>
                                </div>

                                <div class="mb-2">
                                    <small class="text-muted">Member Since:</small>
                                    <span class="float-end"><?php echo date('M Y', strtotime($student['created_at'])); ?></span>
                                </div>

                                <?php
                                // Get book statistics
                                $stmt = $pdo->prepare("SELECT COUNT(*) as count FROM issued_books WHERE student_id = ?");
                                $stmt->execute([$student['student_id']]);
                                $total_books = $stmt->fetch()['count'];

                                $stmt = $pdo->prepare("SELECT COUNT(*) as count FROM issued_books WHERE student_id = ? AND status = 'issued'");
                                $stmt->execute([$student['student_id']]);
                                $current_books = $stmt->fetch()['count'];
                                ?>

                                <div class="mb-2">
                                    <small class="text-muted">Total Books Issued:</small>
                                    <span class="float-end"><?php echo $total_books; ?></span>
                                </div>

                                <div class="mb-2">
                                    <small class="text-muted">Currently Issued:</small>
                                    <span class="float-end"><?php echo $current_books; ?></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
