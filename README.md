# php-test-connectivity

# Containers playground - Quick testing

docker push lmldocker/php-test-connectivity:2.0


# GOAL

  Test containers connectivity retrieving text value from one container to another one.
  Example:
  First container request via HTTP a text content from a certain URL.
  You can deploy 2 containers to make this communication as an example.


# Source code

    index.php

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


     remote-content.php

            <?php
            echo $_ENV["TEST_CONTENT"];
            ?>

# Starting container with docker

  001

      docker run --name php-test-001                   \
       -p 5580:80                                      \
       --env TEST_HOST=192.168.1.9                     \
       --env TEST_PORT=5581                            \
       --env TEST_ENDPOINT=remote-content.php         \
       --env TEST_CONTENT='I-am-php-test-001-contanier-port-5580'         \
       --cpus="0.5"                                    \
       --memory="50m" --memory-reservation="50m"       \
       --rm                                            \
       lmldocker/php-test-connectivity:2.0

  002

      docker run --name php-test-002                   \
       -p 5581:80                                      \
       --env TEST_HOST=192.168.1.9                     \
       --env TEST_PORT=5580                            \
       --env TEST_ENDPOINT=remote-content.php          \
       --env TEST_CONTENT='I-am-php-test-002-contanier-port-5581'         \
       --cpus="0.5"                                    \
       --memory="50m" --memory-reservation="50m"       \
       --rm                                            \
       lmldocker/php-test-connectivity:2.0


  Feel free to change it to use --restart=always and detached mode -d where in this case don't forget to remove the --rm remove option.



# USE THEM

  http://192.168.1.9:5580/
      Web is up! php is up!
      ENV TEST_HOST:192.168.1.9
      ENV TEST_PORT:5581
      ENV TEST_ENDPOINT:remote-content.php
      remote_file_name:http://192.168.1.9:5581/remote-content.php
      Testing connectivity with other php-container
      Opening remote file:
      REMOTE_CONTENT:I-am-php-test-002-contanier-port-5581

  http://192.168.1.9:5581/
      Web is up! php is up!
      ENV TEST_HOST:192.168.1.9
      ENV TEST_PORT:5580
      ENV TEST_ENDPOINT:remote-content.php
      remote_file_name:http://192.168.1.9:5580/remote-content.php
      Testing connectivity with other php-container
      Opening remote file:
      REMOTE_CONTENT:I-am-php-test-001-contanier-port-5580




# KUBERNETES

alias k="kubectl"

kubectl apply -f kubernetes-deploy.yaml  --force
alias kk="kubectl get all -n test -o wide"
kubectl get all -n test -o wide

kubectl get all -n test -o yaml > report.bkp.yaml

kubectl expose pod php-test-001-pod -n test --dry-run=client -o yaml

docker exec -ti 8bf4b1e7898c /bin/bash

kubectl describe pod/php-test-001-pod -n test
kubectl describe svc/php-test-001-svc -n test

  curl http://10.96.245.34:80     ok svc
  curl http://10.96.218.131:80     ok svc
  curl http://php-test-002-svc/remote-content.html
       OK
  curl http://php-test-001-svc:80/remote-content.html
       OK
  curl http://php-test-002-svc/remote-content.php
       OK I-am-php-test-002-contanier
  curl http://php-test-001-svc/remote-content.php
       OK I-am-php-test-001-contanier

  curl http://php-test-001-svc.test.svc.cluster.local
       OK
  root@php-test-001-pod:/etc# curl http://php-test-001-svc.test.svc.cluster.local/remote-content.html
       Hello, I am the remote content!

export TEST_HOST=php-test-001-svc.test.svc.cluster.local
export TEST_HOST=php-test-002-svc.test.svc.cluster.local

docker exec -ti labolida-cluster-control-plane /bin/bash
docker exec -ti labolida-cluster-worker2 /bin/bash

crictl ps
crictl pods

IN CONTAINER-002
crictl exec -ti 309e729fdaf6f cat /etc/hosts
crictl exec -ti 309e729fdaf6f /bin/bash



### Author
by leonardo.labolida.com  --  04-JAN-2023
