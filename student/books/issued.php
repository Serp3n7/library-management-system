<?php
session_start();
include '../../config/database.php';

if (!isset($_SESSION['student_id'])) {
    header('Location: ../index.php');
    exit();
}

// Get student info
$stmt = $pdo->prepare("SELECT student_id FROM students WHERE id = ?");
$stmt->execute([$_SESSION['student_id']]);
$student = $stmt->fetch();

// Get issued books
$stmt = $pdo->prepare("
    SELECT ib.*, b.book_name, b.isbn, a.author_name, c.category_name
    FROM issued_books ib 
    JOIN books b ON ib.book_id = b.id 
    JOIN authors a ON b.author_id = a.id
    JOIN categories c ON b.category_id = c.id
    WHERE ib.student_id = ? AND ib.status = 'issued'
    ORDER BY ib.issued_date DESC
");
$stmt->execute([$student['student_id']]);
$issued_books = $stmt->fetchAll();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issued Books - Library Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../../assets/css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <a class="navbar-brand" href="../dashboard.php">
                <i class="fas fa-book me-2"></i>
                Online Library Management System
            </a>
            <div class="navbar-nav ms-auto">
                <a href="../logout.php" class="btn btn-outline-light">
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
                            <a class="nav-link" href="../dashboard.php">
                                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="issued.php">
                                <i class="fas fa-book-open me-2"></i> Issued Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="history.php">
                                <i class="fas fa-history me-2"></i> Book History
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../profile/">
                                <i class="fas fa-user me-2"></i> My Profile
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">My Issued Books</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <span class="badge bg-info fs-6">Total: <?php echo count($issued_books); ?> books</span>
                    </div>
                </div>

                <?php if (empty($issued_books)): ?>
                    <div class="card">
                        <div class="card-body text-center py-5">
                            <i class="fas fa-book-open fa-4x text-muted mb-4"></i>
                            <h4 class="text-muted">No books currently issued</h4>
                            <p class="text-muted">Contact the librarian to issue books from the library collection.</p>
                        </div>
                    </div>
                <?php else: ?>
                    <div class="row">
                        <?php foreach ($issued_books as $book): ?>
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><?php echo htmlspecialchars($book['book_name']); ?></h5>
                                    <h6 class="card-subtitle mb-2 text-muted">by <?php echo htmlspecialchars($book['author_name']); ?></h6>
                                    
                                    <div class="mb-2">
                                        <small class="text-muted">Category:</small>
                                        <span class="badge bg-secondary"><?php echo htmlspecialchars($book['category_name']); ?></span>
                                    </div>

                                    <div class="mb-2">
                                        <small class="text-muted">ISBN:</small>
                                        <code><?php echo htmlspecialchars($book['isbn']); ?></code>
                                    </div>

                                    <hr>

                                    <div class="row text-center">
                                        <div class="col-6">
                                            <small class="text-muted d-block">Issued Date</small>
                                            <strong><?php echo date('M d, Y', strtotime($book['issued_date'])); ?></strong>
                                        </div>
                                        <div class="col-6">
                                            <small class="text-muted d-block">Due Date</small>
                                            <strong class="<?php echo (strtotime($book['return_date']) < time()) ? 'text-danger' : 'text-success'; ?>">
                                                <?php echo date('M d, Y', strtotime($book['return_date'])); ?>
                                            </strong>
                                        </div>
                                    </div>

                                    <?php
                                    $return_date = strtotime($book['return_date']);
                                    $today = time();
                                    $days_diff = ceil(($return_date - $today) / (60 * 60 * 24));
                                    ?>

                                    <div class="mt-3 text-center">
                                        <?php if ($days_diff < 0): ?>
                                            <span class="badge bg-danger">Overdue by <?php echo abs($days_diff); ?> days</span>
                                        <?php elseif ($days_diff == 0): ?>
                                            <span class="badge bg-warning">Due Today</span>
                                        <?php elseif ($days_diff <= 3): ?>
                                            <span class="badge bg-warning">Due in <?php echo $days_diff; ?> days</span>
                                        <?php else: ?>
                                            <span class="badge bg-success"><?php echo $days_diff; ?> days remaining</span>
                                        <?php endif; ?>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
