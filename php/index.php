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
  if ($q == "register") {

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
  if ($q == "chats") {

    $phone = $_POST["user_id"];

    $results = $db->run(sprintf(
      "
      select `user`.`name` as `sender_name`, `message`.`text` as `last_message`, `message`.`timestamp` as `timestamp`
      from `sends_user`, `message`, `user`
      where `receiver_id` = %s and `message_id` = `message`.`id` and `user`.`id` = `sender_id`
      group by `sender_id`  
      ORDER BY `message`.`timestamp` DESC;
      ",
      $_POST["phone"]));

    done($results);
  }

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
    $conn = mysqli_connect("localhost", "root", "");
    $conn->query(" create database if not exists goat ");
    $conn->close();

    // Connect to database
    parent::__construct("mysql:host=localhost;dbname=goat", "root", "");
    $this->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // 1. user
    $this->run(
      "
      create table if not exists `user` (
      `id` int AUTO_INCREMENT PRIMARY KEY,
      `name` varchar(30) NOT NULL,
      `phone` char(11) NOT NULL
      );
      "
    );

    // 2. group 
    $this->run(
      "
      create table if not exists `group` (
      `id` int AUTO_INCREMENT PRIMARY KEY,
      `name` varchar(30) NOT NULL
      );
      "
    );

    // 3. broadcast
    $this->run(
      "
      create table if not exists `broadcast` (
      `id` int AUTO_INCREMENT PRIMARY KEY,
      `sender_id` int not null,
      FOREIGN KEY (`sender_id`) REFERENCES `user`(`id`)
      );
      "
    );

    // 4. blocks_user
    $this->run(
      "
      create table if not exists `blocks_user` (
      `blocked_id` int not null,
      `blocker_id` int not null,
      FOREIGN KEY (`blocked_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`blocker_id`) REFERENCES `user`(`id`)
      );
      "
    );

    // 5. message
    $this->run(
      "
      create table if not exists `message` (
      `id` int AUTO_INCREMENT PRIMARY KEY,
      `text` varchar(1000) not null,
      `timestamp` timestamp
      );
      "
    );

    // 6. sends_user
    $this->run(
      "
      create table if not exists `sends_user` (
      `receiver_id` int not null,
      `sender_id` int not null,
      `message_id` int not null,
      FOREIGN KEY (`receiver_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`sender_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`message_id`) REFERENCES `message`(`id`)
      );
      "
    );

    // 7. joins_group
    $this->run(
      "
      create table if not exists `joins_group` (
      `user_id` int not null,
      `group_id` int not null,
      `is_admin` boolean not null,
      FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`group_id`) REFERENCES `group`(`id`)
      );
      "
    );

    // 8. receives_broadcast
    $this->run(
      "
      create table if not exists `receives_broadcast` (
      `broadcast_id` int not null,
      `receiver_id` int not null,
      FOREIGN KEY (`broadcast_id`) REFERENCES `broadcast`(`id`),
      FOREIGN KEY (`receiver_id`) REFERENCES `user`(`id`)
      );
      "
    );

    // 9. sends_group
    $this->run(
      "
      create table if not exists `sends_group` (
      `group_id` int not null,
      `sender_id` int not null,
      `message_id` int not null,
      FOREIGN KEY (`group_id`) REFERENCES `group`(`id`),
      FOREIGN KEY (`sender_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`message_id`) REFERENCES `message`(`id`)
      );
      "
    );

    // 10. sends_broadcast
    $this->run(
      "
      create table if not exists `sends_broadcast` (
      `broadcast_id` int not null,
      `message_id` int not null,
      FOREIGN KEY (`broadcast_id`) REFERENCES `broadcast`(`id`),
      FOREIGN KEY (`message_id`) REFERENCES `message`(`id`)
      );
      "
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
