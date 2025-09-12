<?php
// Common utility functions for the library management system

function sanitizeInput($input) {
    return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
}

function generateStudentId($pdo) {
    do {
        $id = 'STU' . str_pad(rand(1, 9999), 4, '0', STR_PAD_LEFT);
        $stmt = $pdo->prepare("SELECT id FROM students WHERE student_id = ?");
        $stmt->execute([$id]);
    } while ($stmt->fetch());
    
    return $id;
}

function isValidEmail($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL);
}

function calculateFine($return_date, $actual_return_date = null) {
    $return_timestamp = strtotime($return_date);
    $actual_timestamp = $actual_return_date ? strtotime($actual_return_date) : time();
    
    if ($actual_timestamp <= $return_timestamp) {
        return 0; // No fine
    }
    
    $days_overdue = ceil(($actual_timestamp - $return_timestamp) / (60 * 60 * 24));
    return $days_overdue * 5; // $5 per day fine
}

function formatDate($date) {
    return date('M d, Y', strtotime($date));
}

function formatDateTime($datetime) {
    return date('M d, Y - h:i A', strtotime($datetime));
}

function getBookStatus($issue_date, $return_date, $status) {
    if ($status === 'returned') {
        return ['class' => 'success', 'text' => 'Returned'];
    }
    
    $today = time();
    $return_timestamp = strtotime($return_date);
    
    if ($today > $return_timestamp) {
        return ['class' => 'danger', 'text' => 'Overdue'];
    } elseif (date('Y-m-d', $today) === date('Y-m-d', $return_timestamp)) {
        return ['class' => 'warning', 'text' => 'Due Today'];
    } else {
        return ['class' => 'primary', 'text' => 'Active'];
    }
}

function sendEmail($to, $subject, $message) {
    // Simple email function - can be enhanced with proper SMTP
    $headers = "MIME-Version: 1.0" . "\r\n";
    $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
    $headers .= 'From: Library Management System <noreply@library.com>' . "\r\n";
    
    return mail($to, $subject, $message, $headers);
}

function logActivity($pdo, $user_type, $user_id, $action, $description) {
    try {
        $stmt = $pdo->prepare("INSERT INTO activity_logs (user_type, user_id, action, description, created_at) VALUES (?, ?, ?, ?, NOW())");
        $stmt->execute([$user_type, $user_id, $action, $description]);
    } catch (PDOException $e) {
        // Log error but don't break the application
        error_log("Failed to log activity: " . $e->getMessage());
    }
}
?>
