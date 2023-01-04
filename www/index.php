<html>
Web is up!

<?php
echo "php is up!";

$TEST_HOST = $_ENV["TEST_HOST"];
$TEST_PORT = $_ENV["TEST_PORT"];
$TEST_ENDPOINT = $_ENV["TEST_ENDPOINT"];

echo "<br> ENV TEST_HOST:"     . $TEST_HOST;
echo "<br> ENV TEST_PORT:"     . $TEST_PORT;
echo "<br> ENV TEST_ENDPOINT:" . $TEST_ENDPOINT;

$remote_file_name="http://$TEST_HOST:$TEST_PORT/$TEST_ENDPOINT";
echo "<br> remote_file_name:" . $remote_file_name;

echo "<br> Testing connectivity with other php-container";
echo "<br> Opening remote file:";

$fp = fopen ( $remote_file_name, "r" );
  if (!$fp) {
    echo "<br> ERROR Unable to open remote file " . $remote_file_name ;
    exit;
  }
  while ( ! feof ($fp) ) {
    #$line = fgets ($file, 1024);
    $content .= fread( $fp, 1024 /*filesize($filename)*/ );
  }
  echo "<br> REMOTE_CONTENT:";
  echo "<hr>" . $content;
fclose($fp);
?>
</html>
