<?php 


try {

  $db = new Database();

  $q = $_POST["q"];

  //////////////////////////////////////////////////////
  if ($q == "user") {

    $results = $db->run(sprintf("select * from user where id = %s", $_POST["user_id"]));

    done($results);
  }

  //////////////////////////////////////////////////////
  if ($q == "is_admin") {

    $results = $db->run(sprintf("
      SELECT is_admin 
      FROM joins_group
      WHERE user_id = %s AND group_id = %s;
      ", $_POST["user_id"], $_POST["selected_id"] ));

    done($results);
  } 
  //////////////////////////////////////////////////////
  if ($q == "is_blocker") {

    $results = $db->run(sprintf("
      SELECT COUNT(*) AS is_blocker
      FROM blocks_user
      WHERE blocked_id = %s AND blocker_id = %s;
      ", $_POST["user_id"], $_POST["selected_id"] ));

    done($results);
  } 
  //////////////////////////////////////////////////////
  if ($q == "is_blocked") {

    $results = $db->run(sprintf("
      SELECT COUNT(*) AS is_blocked
      FROM blocks_user
      WHERE blocker_id = %s AND blocked_id = %s;
      ", $_POST["user_id"], $_POST["selected_id"] ));

    done($results);
  }

  
  //////////////////////////////////////////////////////
  if ($q == "blocks_user") {

    $results = $db->run(sprintf("
      INSERT INTO blocks_user(blocker_id, blocked_id) VALUES (%s, %s);
      ", $_POST["user_id"], $_POST["selected_id"]));

    done();
  }


  //////////////////////////////////////////////////////
  if ($q == "unblocks_user") {

    $results = $db->run(sprintf("
      DELETE FROM blocks_user 
      WHERE blocker_id = %s AND blocked_id = %s;
      ", $_POST["user_id"], $_POST["selected_id"]));

    done();
  }
 
  //////////////////////////////////////////////////////
  if ($q == "delete_chat") {

    $results = $db->run(sprintf("
      DELETE FROM sends_user
      WHERE (sender_id = %s AND receiver_id = %s) OR 
            (sender_id = %s AND receiver_id = %s);
      DELETE FROM message
      WHERE id NOT IN (
          SELECT sb.message_id
          FROM sends_broadcast AS sb
      ) AND id NOT IN (
          SELECT su.message_id
          FROM sends_user AS su 
      ) AND id NOT IN (
          SELECT sg.message_id
          FROM sends_group AS sg
      );
      ", $_POST["user_id"], $_POST["selected_id"], 
      $_POST["selected_id"], $_POST["user_id"]));

    done();
  } 
  //////////////////////////////////////////////////////
  if ($q == "delete_broadcast") {

    $results = $db->run(sprintf("
      DELETE FROM receives_broadcast
      WHERE broadcast_id = %s;
      DELETE FROM sends_broadcast
      WHERE broadcast_id = %s;
      DELETE FROM broadcast
      WHERE id = %s;
      DELETE FROM message
      WHERE id NOT IN (
          SELECT sb.message_id
          FROM sends_broadcast AS sb
      ) AND id NOT IN (
          SELECT su.message_id
          FROM sends_user AS su 
      ) AND id NOT IN (
          SELECT sg.message_id
          FROM sends_group AS sg
      );
      ", $_POST["selected_id"], $_POST["selected_id"], 
      $_POST["selected_id"]));

    done();
  }

  //////////////////////////////////////////////////////
  if ($q == "delete_group") {

    $results = $db->run(sprintf("
      DELETE FROM joins_group
      WHERE group_id = %s;
      DELETE FROM sends_group
      WHERE group_id = %s;
      DELETE FROM group
      WHERE id = %s;
      DELETE FROM message
      WHERE id NOT IN (
          SELECT sb.message_id
          FROM sends_broadcast AS sb
      ) AND id NOT IN (
          SELECT su.message_id
          FROM sends_user AS su 
      ) AND id NOT IN (
          SELECT sg.message_id
          FROM sends_group AS sg
      );
      ", $_POST["selected_id"], $_POST["selected_id"], 
      $_POST["selected_id"]));

    done();
  }
  
  //////////////////////////////////////////////////////
  if ($q == "leave_group") {

    $results = $db->run(sprintf("
      DELETE FROM joins_group 
      WHERE user_id = %s AND group_id = %s",
      $_POST["user_id"], 
      $_POST["selected_id"], 
    ));

    done();
  }

  //////////////////////////////////////////////////////
  if ($q == "contacts") {

    $results = $db->run(sprintf("select * from user where id <> %s", $_POST["user_id"]));

    if (count($results) == 0) 
      error("No contacts other than you");

    done($results);
  }

  //////////////////////////////////////////////////////
  if ($q == "add_members") {
    if (strlen($_POST["ids"]) == 0)
    error("No users were selected");

    $parts = explode(" ", $_POST["ids"]);

    $query = sprintf("
      INSERT INTO `joins_group` VALUES 
      (%s, %s, false)
      ", $parts[0], $_POST["selected_id"]);

    $parts_slice = array_slice($parts, 1);
    foreach ($parts_slice as $part) {
      if (strlen($part) != 0) {
        $query .= sprintf(",(%s, %s, false)", $part, $_POST["selected_id"]);
      }
    }

    done($results);
  }

  //////////////////////////////////////////////////////
  if ($q == "create_group") {
    if (strlen($_POST["name"]) == 0) 
    error("Name field is empty");

    if (strlen($_POST["ids"]) == 0)
    error("No users were selected");

    $query = sprintf("
      INSERT INTO `group`(name) VALUES ('%s');
      INSERT INTO `joins_group` VALUES 
      (%s, LAST_INSERT_ID(), true)
      ", $_POST["name"], $_POST["user_id"]);

    $parts = explode(" ", $_POST["ids"]);
    foreach ($parts as $part) {
      if (strlen($part) != 0) {
        $query .= sprintf(",(%s, LAST_INSERT_ID(), false)", $part);
      }
    }

    $results = $db->run($query);
    $results = $db->run(" 
      SELECT id, name
      FROM `group`
      ORDER BY id DESC
      LIMIT 1
      ");

    done($results);
  }


  //////////////////////////////////////////////////////
  if ($q == "create_broadcast") {
    if (strlen($_POST["ids"]) == 0)
    error("No users were selected");

    $query = sprintf("
      INSERT INTO broadcast(sender_id) VALUES (%s);
      INSERT INTO receives_broadcast VALUES 
      ", $_POST["user_id"]);

    $parts = explode(" ", $_POST["ids"]);
    foreach ($parts as $index => $part) {
      if (strlen($part) != 0) {
        if ($index > 0) {
          $query .= ",";
        }
        $query .= sprintf("(LAST_INSERT_ID(), %s)", $part);
      }
    }

    $results = $db->run($query);
    $results = $db->run(" 
      SELECT rb.broadcast_id AS id, u.name 
      FROM user AS u
      JOIN receives_broadcast AS rb
        ON u.id = rb.receiver_id AND rb.broadcast_id =(
          SELECT MAX(b.id)
          FROM broadcast AS b 
        )
      ");

    done($results);
  }

  //////////////////////////////////////////////////////
  if ($q == "sign_in") {

    $phone = $_POST["phone"];

    if (!ctype_digit($phone) || strlen($phone) != 11 || substr($phone, 0, 2) != "01") 
      error("Invalid or not a phone number");

    $results = $db->run(sprintf("select id, name from user where phone = '%s'", $_POST["phone"]));

    if (count($results) == 0) 
      error("Not registered yet");

    done($results);
  } 

  //////////////////////////////////////////////////////
  if ($q == "sign_up") {

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
  if ($q == "update_name") {
    $name = $_POST["name"];

    if (strlen($name) >= 30 || strlen($name) < 2) 
    error("Empty name field or not in range 2..29 letters");

    $results = $db->run(sprintf(" 
      UPDATE user 
      SET name = '%s'
      WHERE id = %s;
      ", 
      $_POST["name"], $_POST["user_id"]));

    done();
  }

   //////////////////////////////////////////////////////
  if ($q == "update_group_name") {
    $name = $_POST["name"];

    if (strlen($name) >= 30 || strlen($name) < 2) 
    error("Empty name field or not in range 2..29 letters");

    $results = $db->run(sprintf(" 
      UPDATE `group`
      SET name = '%s'
      WHERE id = %s;
      ", 
      $_POST["name"], $_POST["selected_id"]));

    done();
  }

  //////////////////////////////////////////////////////
  if ($q == "update_phone") {

    $phone = $_POST["phone"];

    if (!ctype_digit($phone) || strlen($phone) != 11 || substr($phone, 0, 2) != "01") 
      error("Invalid or not a phone number");

    $results = $db->run(sprintf("select id from user where phone = '%s'", $_POST["phone"]));

    if (count($results) != 0) 
    error("That phone is used by someone else");

    $results = $db->run(sprintf(" 
      UPDATE user 
      SET phone = '%s'
      WHERE id = %s;
      ", 
      $_POST["phone"], $_POST["user_id"]));

    done();
  }

  //////////////////////////////////////////////////////
  if ($q == "chats") {

    $results = $db->run(sprintf("      
      SELECT sender_id+receiver_id-%s as id, name, text as last_message, timestamp
      FROM sends_user as s1
      JOIN message ON message.id = s1.message_id
      JOIN user ON user.id = sender_id+receiver_id-%s
      WHERE (s1.sender_id=%s OR s1.receiver_id=%s) AND s1.message_id = (
      SELECT MAX(message_id)
      FROM sends_user as s2
      WHERE (s2.sender_id=s1.sender_id AND s2.receiver_id=s1.receiver_id) OR
      (s2.sender_id=s1.receiver_id AND s2.receiver_id=s1.sender_id)
      )
      ORDER BY message.id DESC
      ", $_POST["user_id"], $_POST["user_id"], $_POST["user_id"], $_POST["user_id"]));

    if (count($results) == 0) 
      error("No messages found");

    done($results);
  }

  //////////////////////////////////////////////////////
  if ($q == "broadcasts") {

    $results = $db->run(sprintf("      
      SELECT b.id, m.text as last_message, m.timestamp, u.name
      FROM broadcast AS b
      LEFT JOIN sends_broadcast AS sb
              ON sb.message_id = (
                      SELECT MAX(sb2.message_id)
                      FROM sends_broadcast AS sb2
                      WHERE sb2.broadcast_id = b.id
              )
      LEFT JOIN message as m 
              ON m.id = sb.message_id
      LEFT JOIN user as u 
              ON u.id IN (
              SELECT rb.receiver_id 
              FROM receives_broadcast as rb
              WHERE rb.broadcast_id = b.id
          )
      WHERE b.sender_id = %s
      ORDER BY m.id DESC, u.name;
      ", $_POST["user_id"]));

    if (count($results) == 0) 
      error("No broadcasts found");

    done($results);
  }

   //////////////////////////////////////////////////////
  if ($q == "groups") {

    $results = $db->run(sprintf("      
      SELECT g.id as `id`, g.name as `name`, 
      u.name as `sender_name`, m.text as `text`, m.timestamp as `timestamp`
      FROM joins_group as jg
      JOIN `group` as g 
      ON g.id = jg.group_id
      LEFT JOIN `sends_group` as sg
      ON sg.group_id = g.id AND sg.message_id = (
      SELECT MAX(sg2.message_id) 
      FROM `sends_group` as sg2
      WHERE sg2.group_id = g.id
      )
      LEFT JOIN `message` as m 
      ON m.id = sg.message_id
      LEFT JOIN `user` as u 
      ON u.id = sg.sender_id
      WHERE jg.user_id = %s
      ORDER BY m.id DESC, g.name;
      ", $_POST["user_id"]));

    if (count($results) == 0) 
      error("No groups found");

    done($results);
  }


  //////////////////////////////////////////////////////
  if ($q == "group_page") {

    $results = $db->run(sprintf("
      SELECT u.id as sender_id, u.name as sender_name, m.text as text, m.timestamp as timestamp
      FROM sends_group as sg 
      JOIN user as u 
      ON u.id = sg.sender_id
      JOIN message as m 
      ON m.id = sg.message_id
      WHERE sg.group_id = %s
      ORDER BY m.id, sg.group_id;
      ", $_POST["selected_id"]));

    if (count($results) == 0) 
      error("No messages found");

    done($results);
  }

  //////////////////////////////////////////////////////
  if ($q == "chat_page") {

    $results = $db->run(sprintf("
      SELECT sender_id, text, timestamp
      FROM sends_user
      JOIN message ON message.id = message_id
      WHERE sender_id=%s AND receiver_id=%s OR sender_id=%s AND receiver_id=%s
      ORDER BY message_id 
      ", $_POST["user_id"], $_POST["selected_id"], $_POST["selected_id"], $_POST["user_id"]));

    if (count($results) == 0) 
      error("No messages found");

    done($results);
  }

  //////////////////////////////////////////////////////
  if ($q == "broadcast_page") {

    $results = $db->run(sprintf("
      SELECT m.text, m.timestamp
      FROM sends_broadcast as sb
      JOIN message as m ON m.id = sb.message_id
      WHERE broadcast_id = %s
      ORDER BY m.id, sb.broadcast_id
      ", $_POST["selected_id"]));

    if (count($results) == 0) 
      error("No messages found");

    done($results);
  }
  
  //////////////////////////////////////////////////////
  if ($q == "sends_user") {

    $results = $db->run(sprintf("
      INSERT INTO message(text) VALUES ('%s');
      INSERT INTO sends_user(sender_id, receiver_id, message_id) VALUES (%s, %s, LAST_INSERT_ID());
      ", $_POST["text"], $_POST["user_id"], $_POST["selected_id"]));

    done();
  }

  
  //////////////////////////////////////////////////////
  if ($q == "sends_broadcast") {

    $results = $db->run(sprintf("
      INSERT INTO message(text) VALUES ('%s');
      INSERT INTO sends_broadcast VALUES (%s, LAST_INSERT_ID());
      ", $_POST["text"], $_POST["selected_id"]));

    $results = $db->run(sprintf("
      INSERT INTO sends_user
      SELECT u.id, %s, (
        SELECT MAX(m.id)
        FROM message AS m
      )
      FROM user AS u
      WHERE u.id IN(
        SELECT rb.receiver_id
        FROM receives_broadcast AS rb
        WHERE rb.broadcast_id = %s
      )
      ", $_POST["user_id"], $_POST["selected_id"]));

    done();
  }
  
  //////////////////////////////////////////////////////
  if ($q == "sends_group") {

    $results = $db->run(sprintf("
      INSERT INTO message(text) VALUES ('%s');
      INSERT INTO sends_group(sender_id, group_id, message_id) VALUES (%s, %s, LAST_INSERT_ID());
      ", $_POST["text"], $_POST["user_id"], $_POST["selected_id"]));

    done();
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

function done($arrayOfMaps=[[""=>""]])
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
