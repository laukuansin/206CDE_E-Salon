<?php

class ControllerApiSetting extends Controller{

    public function getSetting()
    {
        $json = array();

        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"
            );
            $this->response->setOutput(json_encode($json));
            return;
        } 
        $this->load->model('service/setting');

        $result=$this->model_service_setting->getSetting();
        
        if(empty($result))
        {
            $json['response'] = array(
                'msg'       => 'User no found',
                'status'    => 0
            );
            $json['setting'] = [];

        }
        else{
            $decodeResult = json_decode($result['service_setting'],true);
            $buisnessHour=$decodeResult['business_hour'];
            $timeFormat="g:i A";

                

            $monday=array(
                'open_time'=>date($timeFormat,strtotime($buisnessHour['Monday']['start_time'] . " " .  $buisnessHour['Monday']['start_meridiem'])),
                'close_time'=>date($timeFormat,strtotime($buisnessHour['Monday']['end_time'] . " " .  $buisnessHour['Monday']['end_meridiem'])),
                'is_open'=>$buisnessHour['Monday']['is_open']==1?true:false  
            );
            $tuesday=array(
                'open_time'=>date($timeFormat,strtotime($buisnessHour['Tuesday']['start_time'] . " " .  $buisnessHour['Tuesday']['start_meridiem'])),
                'close_time'=>date($timeFormat,strtotime($buisnessHour['Tuesday']['end_time'] . " " .  $buisnessHour['Tuesday']['end_meridiem'])),
                'is_open'=>$buisnessHour['Tuesday']['is_open']==1?true:false  
            );
            $wednesday=array(
                'open_time'=>date($timeFormat,strtotime($buisnessHour['Wednesday']['start_time'] . " " .  $buisnessHour['Wednesday']['start_meridiem'])),
                'close_time'=>date($timeFormat,strtotime($buisnessHour['Wednesday']['end_time'] . " " .  $buisnessHour['Wednesday']['end_meridiem'])),
                'is_open'=>$buisnessHour['Wednesday']['is_open']==1?true:false  
            );
            $thursday=array(
                'open_time'=>date($timeFormat,strtotime($buisnessHour['Thursday']['start_time'] . " " .  $buisnessHour['Thursday']['start_meridiem'])),
                'close_time'=>date($timeFormat,strtotime($buisnessHour['Thursday']['end_time'] . " " .  $buisnessHour['Thursday']['end_meridiem'])),
                'is_open'=>$buisnessHour['Thursday']['is_open']==1?true:false  
            );
            $friday=array(
                'open_time'=>date($timeFormat,strtotime($buisnessHour['Friday']['start_time'] . " " .  $buisnessHour['Friday']['start_meridiem'])),
                'close_time'=>date($timeFormat,strtotime($buisnessHour['Friday']['end_time'] . " " .  $buisnessHour['Friday']['end_meridiem'])),
                'is_open'=>$buisnessHour['Friday']['is_open']==1?true:false  
            );
            $saturday=array(
                'open_time'=>date($timeFormat,strtotime($buisnessHour['Saturday']['start_time'] . " " .  $buisnessHour['Saturday']['start_meridiem'])),
                'close_time'=>date($timeFormat,strtotime($buisnessHour['Saturday']['end_time'] . " " .  $buisnessHour['Saturday']['end_meridiem'])),
                'is_open'=>$buisnessHour['Saturday']['is_open']==1?true:false  
            );
            $sunday=array(
                'open_time'=>date($timeFormat,strtotime($buisnessHour['Sunday']['start_time'] . " " .  $buisnessHour['Sunday']['start_meridiem'])),
                'close_time'=>date($timeFormat,strtotime($buisnessHour['Sunday']['end_time'] . " " .  $buisnessHour['Sunday']['end_meridiem'])),
                'is_open'=>$buisnessHour['Sunday']['is_open']==1?true:false  
            );

            $json['monday']=$monday;
            $json['tuesday']=$tuesday;
            $json['wednesday']=$wednesday;
            $json['thursday']=$thursday;
            $json['friday']=$friday;
            $json['saturday']=$saturday;
            $json['sunday']=$sunday;
            $json['appointment_interval']=(int)$decodeResult['appointment_interval'];
            $json['travel_time']=(int)$decodeResult['travel_time'];
            $json['cancel_time']=(int)$decodeResult['cancellation_time'];
            $json['response'] = array(
                'msg'       => 'Get Setting Success',
                'status'    => 1
            );
        }

        $this->response->setOutput(json_encode($json));

    }

    public function editSetting()
    {
        $json = array();
		$this->load->language('service/setting');
        $this->load->model('service/setting');

        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"
            );
            $this->response->setOutput(json_encode($json));
            return;
        } 

        if($this->request->server['REQUEST_METHOD'] == 'POST' && $this->validateForm($error)){
            $timeFormat="g.i";
            $meridiemFormat="A";
            
            $mon=array(
                'is_open'=> $this->request->post['monIsOpen']=="true"?"1":"0",
                'start_time'=>date($timeFormat,strtotime($this->request->post['monOpenTime'])),
                'start_meridiem'=>date($meridiemFormat,strtotime($this->request->post['monOpenTime'])),
                'end_time'=>date($timeFormat,strtotime($this->request->post['monCloseTime'])),
                'end_meridiem'=>date($meridiemFormat,strtotime($this->request->post['monCloseTime']))
            );
            $tues=array(
                'is_open'=> $this->request->post['tuesIsOpen']=="true"?"1":"0",
                'start_time'=>date($timeFormat,strtotime($this->request->post['tuesOpenTime'])),
                'start_meridiem'=>date($meridiemFormat,strtotime($this->request->post['tuesOpenTime'])),
                'end_time'=>date($timeFormat,strtotime($this->request->post['tuesCloseTime'])),
                'end_meridiem'=>date($meridiemFormat,strtotime($this->request->post['tuesCloseTime']))
            );
            $wed=array(
                'is_open'=> $this->request->post['wedIsOpen']=="true"?"1":"0",
                'start_time'=>date($timeFormat,strtotime($this->request->post['wedOpenTime'])),
                'start_meridiem'=>date($meridiemFormat,strtotime($this->request->post['wedOpenTime'])),
                'end_time'=>date($timeFormat,strtotime($this->request->post['wedCloseTime'])),
                'end_meridiem'=>date($meridiemFormat,strtotime($this->request->post['wedCloseTime']))
            );
            $thurs=array(
                'is_open'=> $this->request->post['thursIsOpen']=="true"?"1":"0",
                'start_time'=>date($timeFormat,strtotime($this->request->post['thursOpenTime'])),
                'start_meridiem'=>date($meridiemFormat,strtotime($this->request->post['thursOpenTime'])),
                'end_time'=>date($timeFormat,strtotime($this->request->post['thursCloseTime'])),
                'end_meridiem'=>date($meridiemFormat,strtotime($this->request->post['thursCloseTime']))
            );
            $fri=array(
                'is_open'=> $this->request->post['friIsOpen']=="true"?"1":"0",
                'start_time'=>date($timeFormat,strtotime($this->request->post['friOpenTime'])),
                'start_meridiem'=>date($meridiemFormat,strtotime($this->request->post['friOpenTime'])),
                'end_time'=>date($timeFormat,strtotime($this->request->post['friCloseTime'])),
                'end_meridiem'=>date($meridiemFormat,strtotime($this->request->post['friCloseTime']))
            );
            $sat=array(
                'is_open'=> $this->request->post['satIsOpen']=="true"?"1":"0",
                'start_time'=>date($timeFormat,strtotime($this->request->post['satOpenTime'])),
                'start_meridiem'=>date($meridiemFormat,strtotime($this->request->post['satOpenTime'])),
                'end_time'=>date($timeFormat,strtotime($this->request->post['satCloseTime'])),
                'end_meridiem'=>date($meridiemFormat,strtotime($this->request->post['satCloseTime']))
            );
            $sun=array(
                'is_open'=> $this->request->post['sunIsOpen']=="true"?"1":"0",
                'start_time'=>date($timeFormat,strtotime($this->request->post['sunOpenTime'])),
                'start_meridiem'=>date($meridiemFormat,strtotime($this->request->post['sunOpenTime'])),
                'end_time'=>date($timeFormat,strtotime($this->request->post['sunCloseTime'])),
                'end_meridiem'=>date($meridiemFormat,strtotime($this->request->post['sunCloseTime']))
            );
            $buisnessHour=array(
                'Monday'=>$mon,
                'Tuesday'=>$tues,
                'Wednesday'=>$wed,
                'Thursday'=>$thurs,
                'Friday'=>$fri,
                'Saturday'=>$sat,
                'Sunday'=>$sun
            );

            $data = array('cancellation_time' => $this->request->post['cancellation_time']
				, 'business_hour' => $buisnessHour
				, 'travel_time' => $this->request->post['travel_time']
				, 'appointment_interval' => $this->request->post['appointment_interval']);
            $this->model_service_setting->updateSetting(json_encode($data));
            $json['response'] = array(
                'status'    => 1,
                'msg'       => "Update Setting Success"
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

    public function validateForm(&$error){
		if(!$this->user->hasPermission('modify', 'service/setting')){
			$error['permission'] = $this->language->get('error_permission');
		}

		if(empty($this->request->post['cancellation_time'])){
			$error['cancellation_time'] = $this->language->get('error_empty_cancellation_time');
		} else if(!is_numeric($this->request->post['cancellation_time'])){
			$error['cancellation_time'] = $this->language->get('error_cancellation_time');
		}

		if(empty($this->request->post['travel_time'])){
			$error['travel_time'] = $this->language->get('error_empty_travel_time');
		} else if(!is_numeric($this->request->post['travel_time'])){
			$error['travel_time'] = $this->language->get('error_travel_time');
		}

		if(empty($this->request->post['appointment_interval'])){
			$error['appointment_interval'] = $this->language->get('error_empty_appointment_interval');
		} else if(!is_numeric($this->request->post['appointment_interval'])){
			$error['appointment_interval'] = $this->language->get('error_appointment_interval');
		}


		return !$error;
	}
}
?>