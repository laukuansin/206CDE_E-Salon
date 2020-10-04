<?php
class ControllerApiStaff extends Controller {
    public function add_staff()
    {
        $username = (isset($this->request->post['username'])) ? $this->request->post['username'] : false;
        $userGroup = (isset($this->request->post['user_group'])) ? $this->request->post['user_group'] : false;
        $firstName = (isset($this->request->post['first_name'])) ? $this->request->post['first_name'] : false;
        $lastName = (isset($this->request->post['last_name'])) ? $this->request->post['last_name'] : false;
        $email = (isset($this->request->post['email'])) ? $this->request->post['email'] : false;
        $image = isset($_FILES['image_path']) ? $_FILES['image_path'] : false;
        $password = (isset($this->request->post['password'])) ? $this->request->post['password'] : false;
        $status = (isset($this->request->post['status'])) ? $this->request->post['status'] : false;

        $this->load->model('api/staff');
        $this->load->library('obfuscate');
		$this->encryptData=new Obfuscate();
		
        if($username&&$userGroup&&$firstName&&$lastName&&$email&&$password&&$status)
        {
            if($userGroup=="Owner")
            {
                $userGroupCode=1;
            }
            else{
                $userGroupCode=10;
            }
            if($status=="Enabled")
            {
                $statusCode=1;
            }
            else{
                $statusCode=0;
            }
            if(!empty($image))
            {
                $img_allowed = array('gif', 'jpeg', 'png', 'jpg');
                if ($image['name']) {
                    $img_filename = $image['name'];
                    $ext = pathinfo($img_filename, PATHINFO_EXTENSION);
                    if (!in_array($ext, $img_allowed)) {
                        $json['error_code'] = [
                            'error' => 3,
                            'msj'   => 'Failed ! Invalid File Format !'
                        ];
                    }
                    else {
                        $image['image']     = $image;
                    
                    } 
                }
            }
          
            $checkUsername=$this->model_api_staff->validateUsername($username);
            if(!$checkUsername)
            {
                $json['error_code'] = 
                [
                    'error' => 1,
                    'msj'   => 'username already exist.'
                ];
            }           
            $checkEmail=$this->model_api_staff->validateEmail($email);
            if(!$checkEmail)
            {
                $json['error_code'] = 
                [
                    'error' => 1,
                    'msj'   => 'email already exist.'
                ];
            }
            if($checkEmail&&$checkUsername)
            {
                $userID=$this->model_api_staff->addStaff($username,$userGroupCode,$firstName,$lastName,$email,$image,$password,$statusCode);
                if(!empty($userID))
                {
                    $authorization = array(
                        'user_id'		=> $userID,
                        'username' 		=> $username,
                        'password' 		=> $password
                    );
                    $key=$this->encryptData->encrypt($authorization);
                    $this->model_api_staff->addAppToken($key,$userID);
                   
                    $json['error_code'] = 
                    [
                        'error' => 0,
                        'msj'   => 'add Staff success.'
                    ];
                }
               
            }           

        }
        else{
            $json['error_code'] = [
                'error' => 1,
                'msj'   => 'Missing Parameter.'
            ];
        }
        $this->response->setOutput(json_encode($json));
    }
}
