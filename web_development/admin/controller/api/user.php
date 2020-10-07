<?php
class ControllerApiUser extends Controller {

    public function add()
    {
        $json = array();
        $error = array();
        $this->load->language('user/user');
        $this->load->model('user/user');

        $this->request->post['image'] = '';
        if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm($error) && (!isset($this->request->files['file']) || $this->upload($error))) {
            $userTokenList = $this->model_user_user->getUserToken();

            $isValid;
            do
            {
                $isValid = true;
                $token = token(32);
                foreach ($userTokenList as $userToken) {
                    $isValid &= ($token != $userToken['user_token']);
                }
            }while(!$isValid);

            $this->request->post['user_token'] = $token;
            $this->model_user_user->addUser($this->request->post);
            $json['response'] = array(
                'status'    => 1,
                'msg'       => $this->language->get('text_success')
            );
        }
        else{
            $json['response'] = array(
                'msg'       => '',
                'status'    => 0
            );
            $json['error'] = $error;
        }
        $this->response->setOutput(json_encode($json));
    }


    protected function upload(&$error){
        $this->load->language('common/filemanager');


        // Check user has permission
        if (!$this->user->hasPermission('modify', 'common/filemanager')) {
            $error['image'] = $this->language->get('error_permission');
        }

        // Make sure we have the correct directory
        if (isset($this->request->get['directory'])) {
            $directory = rtrim(DIR_IMAGE . 'catalog/' . $this->request->get['directory'], '/');
        } else {
            $directory = DIR_IMAGE . 'catalog';
        }

        // Check its a directory
        if (!is_dir($directory) || substr(str_replace('\\', '/', realpath($directory)), 0, strlen(DIR_IMAGE . 'catalog')) != str_replace('\\', '/', DIR_IMAGE . 'catalog')) {
            $error['image'] = $this->language->get('error_directory');
        }

        if (!isset($error['image'])) {

            $file = array();

            if (!empty($this->request->files['file']['name'])) {
                $file = array(
                    'name'     => $this->request->files['file']['name'],
                    'type'     => $this->request->files['file']['type'],
                    'tmp_name' => $this->request->files['file']['tmp_name'],
                    'error'    => $this->request->files['file']['error'],
                    'size'     => $this->request->files['file']['size']
                );
            }

               
            if (is_file($file['tmp_name'])) {
                // Sanitize the filename
                $filename = basename(html_entity_decode($file['name'], ENT_QUOTES, 'UTF-8'));

                // Validate the filename length
                if ((utf8_strlen($filename) < 3) || (utf8_strlen($filename) > 255)) {
                    $error['image'] = $this->language->get('error_filename');
                }

                // Allowed file extension types
                $allowed = array(
                    'jpg',
                    'jpeg',
                    'gif',
                    'png'
                );

                if (!in_array(utf8_strtolower(utf8_substr(strrchr($filename, '.'), 1)), $allowed)) {
                    $error['image'] = $this->language->get('error_filetype');
                }

                // Allowed file mime types
                $allowed = array(
                    'image/jpeg',
                    'image/pjpeg',
                    'image/png',
                    'image/x-png',
                    'image/gif',
                    'image/jpg'
                );

                if (!in_array($file['type'], $allowed)) {
                    $error['image'] = $this->language->get('error_filetype');
                }

                // Return any upload error
                if ($file['error'] != UPLOAD_ERR_OK) {
                    $error['image'] = $this->language->get('error_upload_' . $file['error']);
                }
            } else {
                $error['image'] = $this->language->get('error_upload');
            }

            if (!isset($error['image'])) {
                $this->request->post['image'] =  'catalog/' . $filename;
                move_uploaded_file($file['tmp_name'], $directory . '/' . $filename);
            }
        } 
        return !isset($error['image']);
    }

    protected function validateForm(&$error) {
        if (!$this->user->hasPermission('modify', 'user/user')) {
            $error['warning'] = $this->language->get('error_permission');
        }

        if ((utf8_strlen($this->request->post['username']) < 3) || (utf8_strlen($this->request->post['username']) > 20)) {
            $error['username'] = $this->language->get('error_username');
        }

        $user_info = $this->model_user_user->getUserByUsername($this->request->post['username']);

        if (!isset($this->request->get['user_id'])) {
            if ($user_info) {
                $error['username'] = $this->language->get('error_exists_username');
            }
        } else {
            if ($user_info && ($this->request->get['user_id'] != $user_info['user_id'])) {
                $error['username'] = $this->language->get('error_exists_username');
            }
        }

        if ((utf8_strlen(trim($this->request->post['firstname'])) < 1) || (utf8_strlen(trim($this->request->post['firstname'])) > 32)) {
            $error['firstname'] = $this->language->get('error_firstname');
        }

        if ((utf8_strlen(trim($this->request->post['lastname'])) < 1) || (utf8_strlen(trim($this->request->post['lastname'])) > 32)) {
            $error['lastname'] = $this->language->get('error_lastname');
        }

        if ((utf8_strlen($this->request->post['email']) > 96) || !filter_var($this->request->post['email'], FILTER_VALIDATE_EMAIL)) {
            $error['email'] = $this->language->get('error_email');
        }

        $user_info = $this->model_user_user->getUserByEmail($this->request->post['email']);

        if (!isset($this->request->get['user_id'])) {
            if ($user_info) {
                $error['email'] = $this->language->get('error_exists_email');
            }
        } else {
            if ($user_info && ($this->request->get['user_id'] != $user_info['user_id'])) {
                $error['email'] = $this->language->get('error_exists_email');
            }
        }

        if ($this->request->post['password'] || (!isset($this->request->get['user_id']))) {
            if ((utf8_strlen(html_entity_decode($this->request->post['password'], ENT_QUOTES, 'UTF-8')) < 4) || (utf8_strlen(html_entity_decode($this->request->post['password'], ENT_QUOTES, 'UTF-8')) > 40)) {
                $error['password'] = $this->language->get('error_password');
            }

            if ($this->request->post['password'] != $this->request->post['confirm']) {
                $error['confirm'] = $this->language->get('error_confirm');
            }
        }

        return !$error;
    }
}
