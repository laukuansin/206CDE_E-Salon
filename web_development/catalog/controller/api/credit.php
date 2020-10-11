<?php
class ControllerApiCredit extends Controller {
    public function topUpCustomerCredit()
    {
        //Must have function
        // !!!!!!!!!!!!!!!!!!!
        $json = array();
        if(!$this->customer->isLogged()) {
            $json['response'] = array(
                'status' => -1,
                'msg' => 'Invalid token'
            );
            $this->response->setOutput(json_encode($json));
            return;
        }  

        $this->load->model('account/customer');

        if(isset($this->request->post['credit']) && isset($this->request->post['description'])){
            $this->request->post['customer_id'] = $this->customer->getId();
            $this->request->post['reference']   = $this->getReference();
            $this->model_account_customer->topUpCustomerCredit($this->request->post);

            $json['response'] = [
                'status' => 1,
                'msg'   => 'Top Up successfully.'
            ];
        } else {
            $json['response'] = [
                'status' => 0,
                'msg'   => 'Paramter missing.'
            ];
        }
        $this->response->setOutput(json_encode($json));
    }

    public function getCustomerCredit()
    {
        //Must have function
        // !!!!!!!!!!!!!!!!!!!
        $json = array();
        if(!$this->customer->isLogged()) {
            $json['response'] = array(
                'status' => -1,
                'msg' => 'Invalid token'
            );
            $this->response->setOutput(json_encode($json));
            return;
        }  
            

        $this->load->model('account/customer');
        $creditResult = $this->model_account_customer->getCustomerCredit($this->customer->getId());
        $json['credit'] = is_null($creditResult["total_credit"])? 0 : $creditResult["total_credit"];
        $json['response'] = array(
            'status' => 1,
            'msg'   => 'Get Credit successfully'
        );

        $this->response->setOutput(json_encode($json));
    }

    private function getReference(){
        mt_srand((double)microtime()*10000);
        $charid = md5(uniqid(rand(), true));
        $c = unpack("C*",$charid);
        $c = implode("",$c);
        return substr($c,0,20);
    }

}
?>