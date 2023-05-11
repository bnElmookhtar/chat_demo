<?php 

$debug = true;

try {

  $db = new Database();

  $queryType = $_POST["q"];

  if ($queryType == "login") {
    $db->runEcho(sprintf("select id from uesr where phone = '%s'", $_POST["phone"]));

  } elseif ($queryType == "register") {


  } elseif ($debug) {
    $db->runEcho("select * from user");
    echo "<p>REACHED END</p>";

  }

} catch (\Throwable $th) {
  echo $th;

}


class Database extends PDO
{
  public function __construct()
  {
    // Create database if not exists
    $_ = mysqli_connect("localhost", "root", "");
    $_->query("CREATE DATABASE IF NOT EXISTS goat");
    $_->close();

    // Connect to database
    parent::__construct("mysql:host=localhost;dbname=goat", "root", "");
    $this->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Create tables if not exists
    $this->run(
      "CREATE TABLE IF NOT EXISTS user (
      id int AUTO_INCREMENT PRIMARY KEY,
      name varchar(30) NOT NULL,
      phone char(11) NOT NULL
      );"
    );
  }

  // @param $query SQL Query to run
  public function run($query) : array|bool
  {
    $results = $this->prepare($query, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
    $results->execute();
    return $results->fetchAll();
  }

  // @param $query SQL Query to run
  public function runEcho($query) : void
  {
    echo json_encode($this->run($query));
  }
}

