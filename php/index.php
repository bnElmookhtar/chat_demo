<?php 


try {

  $db = new Database();

  $q = $_POST["q"];

  //////////////////////////////////////////////////////
  if ($q == "login") {

    $phone = $_POST["phone"];

    if (!ctype_digit($phone) || strlen($phone) != 11 || substr($phone, 0, 2) != "01") 
      error("Invalid or not a phone number");

    $results = $db->run(sprintf("select id from user where phone = '%s'", $_POST["phone"]));

    if (count($results) == 0) 
      error("Not registered yet");

    done($results);
  } 

  //////////////////////////////////////////////////////
  elseif ($q == "register") {

    $phone = $_POST["phone"];
    $name = $_POST["name"];

    if (!ctype_digit($phone) || strlen($phone) != 11 || substr($phone, 0, 2) != "01") 
      error("Invalid or not a phone number");

    if (strlen($name) >= 30 || strlen($name) < 2) 
      error("Empty name field or not in range 2..29 letters");

    $results = $db->run(sprintf("select id from user where phone = '%s'", $_POST["phone"]));

    if (count($results) != 0) 
    error("That phone is already registered");

    $results = $db->run(sprintf("insert into user (phone, name) values ('%s', '%s')", 
      $_POST["phone"], $_POST["name"]));

    $results = $db->run(sprintf("select id from user where phone = '%s'", $_POST["phone"]));

    done($results);
  }

  //////////////////////////////////////////////////////

  // only on debug
  done($db->run("select * from user"));

} catch (\Throwable $th) {
  echo $th;

}


function error($msg)
{
  die(sprintf('[{"error":"%s"}]', $msg));
}

function done($arrayOfMaps)
{
  die(json_encode($arrayOfMaps));
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
}
