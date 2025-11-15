<?php

header('Content-Type: application/json');

$data = [
    'pesan' => 'Halo dari Backend PHP!',
    'status' => 'sukses',
    'timestamp' => date('c')
];

echo json_encode($data);
?>