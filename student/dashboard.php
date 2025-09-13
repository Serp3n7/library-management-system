<?php
session_start();
include '../config/database.php';

if (!isset($_SESSION['student_id'])) {
    header('Location: index.php');
    exit();
}

// Get student info
$stmt = $pdo->prepare("SELECT * FROM students WHERE id = ?");
$stmt->execute([$_SESSION['student_id']]);
$student = $stmt->fetch();

// Get issued books
$stmt = $pdo->prepare("
    SELECT ib.*, b.book_name, b.isbn, a.author_name, ib.return_date
    FROM issued_books ib 
    JOIN books b ON ib.book_id = b.id 
    JOIN authors a ON b.author_id = a.id
    WHERE ib.student_id = ? AND ib.status = 'issued'
    ORDER BY ib.issued_date DESC
");
$stmt->execute([$student['student_id']]);
$issued_books = $stmt->fetchAll();

// Get statistics
$stmt = $pdo->prepare("SELECT COUNT(*) as count FROM issued_books WHERE student_id = ?");
$stmt->execute([$student['student_id']]);
$total_issued = $stmt->fetch()['count'];

$stmt = $pdo->prepare("SELECT COUNT(*) as count FROM issued_books WHERE student_id = ? AND status = 'returned'");
$stmt->execute([$student['student_id']]);
$total_returned = $stmt->fetch()['count'];
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Library Management</title>
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
                <span class="navbar-text text-white me-3">
                    Welcome, <?php echo htmlspecialchars($student['fullname']); ?>
                </span>
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
                            <a class="nav-link" href="books/issued.php">
                                <i class="fas fa-book-open me-2"></i> Issued Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="books/history.php">
                                <i class="fas fa-history me-2"></i> Book History
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="profile/">
                                <i class="fas fa-user me-2"></i> My Profile
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="profile/change-password.php">
                                <i class="fas fa-key me-2"></i> Change Password
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Student Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <span class="badge bg-info fs-6">ID: <?php echo $student['student_id']; ?></span>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <div class="card dashboard-card">
                            <div class="card-body">
                                <i class="fas fa-book-open card-icon" style="color: #007bff;"></i>
                                <h3><?php echo count($issued_books); ?></h3>
                                <p>Currently Issued</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4 mb-4">
                        <div class="card dashboard-card">
                            <div class="card-body">
                                <i class="fas fa-books card-icon" style="color: #28a745;"></i>
                                <h3><?php echo $total_issued; ?></h3>
                                <p>Total Books Issued</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4 mb-4">
                        <div class="card dashboard-card">
                            <div class="card-body">
                                <i class="fas fa-undo card-icon" style="color: #ffc107;"></i>
                                <h3><?php echo $total_returned; ?></h3>
                                <p>Books Returned</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Currently Issued Books -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5>Currently Issued Books</h5>
                            </div>
                            <div class="card-body">
                                <?php if (empty($issued_books)): ?>
                                    <div class="text-center py-4">
                                        <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No books currently issued</h5>
                                        <p class="text-muted">Contact the librarian to issue books</p>
                                    </div>
                                <?php else: ?>
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Book Name</th>
                                                    <th>Author</th>
                                                    <th>ISBN</th>
                                                    <th>Issue Date</th>
                                                    <th>Return Date</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php foreach ($issued_books as $book): ?>
                                                <tr>
                                                    <td><?php echo htmlspecialchars($book['book_name']); ?></td>
                                                    <td><?php echo htmlspecialchars($book['author_name']); ?></td>
                                                    <td><?php echo htmlspecialchars($book['isbn']); ?></td>
                                                    <td><?php echo date('M d, Y', strtotime($book['issued_date'])); ?></td>
                                                    <td><?php echo date('M d, Y', strtotime($book['return_date'])); ?></td>
                                                    <td>
                                                        <?php
                                                        $return_date = strtotime($book['return_date']);
                                                        $today = strtotime(date('Y-m-d'));
                                                        
                                                        if ($today > $return_date) {
                                                            echo '<span class="badge bg-danger">Overdue</span>';
                                                        } elseif ($today == $return_date) {
                                                            echo '<span class="badge bg-warning">Due Today</span>';
                                                        } else {
                                                            echo '<span class="badge bg-success">Active</span>';
                                                        }
                                                        ?>
                                                    </td>
                                                </tr>
                                                <?php endforeach; ?>
                                            </tbody>
                                        </table>
                                    </div>
                                <?php endif; ?>
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
