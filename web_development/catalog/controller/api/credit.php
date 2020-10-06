<?php
class ControllerApiCredit extends Controller {
    public function top_up()
    {
        $customer_id = (isset($this->request->post['customer_id'])) ? $this->request->post['customer_id'] : false;
        $credit = (isset($this->request->post['credit'])) ? $this->request->post['credit'] : false;
        $this->load->model('api/credit');
        if($customer_id&&$credit)
        {
           $checkCustomer=$this->model_api_credit->checkCustomer($customer_id);

           if($checkCustomer)
           {
                $description="Top up RM".$credit;
                $reference=$this->getReference();
                $topUp=$this->model_api_credit->topUp($customer_id,$credit,$description,$reference);

                if(empty($topUp))
                {
                    $json['error_code'] = [
                        'error' => 3,
                        'msj'   => 'Top Up Failure.'
                        ];
                }
                else{
                    $json['error_code'] = [
                        'error' => 0,
                        'msj'   => 'Top Up success.'
                        ];
                }
           }
           else{
            $json['error_code'] = [
                'error' => 2,
                'msj'   => 'Customer ID is not exist.'
                ];
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
    public function getReference(){
        mt_srand((double)microtime()*10000);
        $charid = md5(uniqid(rand(), true));
        $c = unpack("C*",$charid);
        $c = implode("",$c);

        return substr($c,0,20);
    }
}
?>