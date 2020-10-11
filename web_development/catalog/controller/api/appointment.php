<?php
class ControllerApiAppointment extends Controller {

	public function getAppointmentListAccepted(){
         //Must have function
        // !!!!!!!!!!!!!!!!!!!
        $json = array();
        $list= array();
        if(!$this->customer->isLogged()) {
            $json['response'] = array(
                'status' => -1,
                'msg' => 'Invalid token'
            );
            $this->response->setOutput(json_encode($json));
            return;
        }
        $this->load->model('appointment/appointment');
        $appointmentList=$this->model_appointment_appointment->getAppointmentListAcceptedByCustomerID($this->customer->getId());
        if(empty($appointmentList))
        {
            $json['list']=array();
            $json['response'] = array(
                'status' => 1,
                'msg'   => 'Appointment is empty now'
            );
        }
        else{
            foreach($appointmentList as $appointment)
            {
                $date=$appointment['appointment_date'];
                $formatDate=date("d-M-Y",strtotime($date));
                $arrayDate=explode('-', $formatDate);
                $year=$arrayDate[2];
                $month=$arrayDate[1];
                $day=$arrayDate[0];
                $list[]=[
                    'appointment_id'=>(int)$appointment['appointment_id'],
                    'date'=>$date,
                    'year'=>$year,
                    'month'=>$month,
                    'day'=>$day,
                    'status'=>$appointment['status'],
                    'worker_name'=>$appointment['username']
                ];
            }
            $json['list']=$list;
            $json['response'] = array(
                'status' => 1,
                'msg'   => 'Get Appointment Success'
            );
        }
        
        
        $this->response->setOutput(json_encode($json));
    }

    public function getAppointmentList()
    {
           //Must have function
        // !!!!!!!!!!!!!!!!!!!
        $json = array();
        $list= array();
        if(!$this->customer->isLogged()) {
            $json['response'] = array(
                'status' => -1,
                'msg' => 'Invalid token'
            );
            $this->response->setOutput(json_encode($json));
            return;
        }
        $this->load->model('appointment/appointment');
        $appointmentList=$this->model_appointment_appointment->getAppointmentListByCustomerID($this->customer->getId());
        if(empty($appointmentList))
        {
            $json['list']=array();
            $json['response'] = array(
                'status' => 1,
                'msg'   => 'Appointment is empty now'
            );
        }
        else{
            foreach($appointmentList as $appointment)
            {
                $date=$appointment['appointment_date'];
                $formatDate=date("d-M-Y-",strtotime($date));
                $time=date('h:i a',strtotime($date));
                $arrayDate=explode('-', $formatDate);
                $year=$arrayDate[2];
                $month=$arrayDate[1];
                $day=$arrayDate[0];
                $list[]=[
                    'appointment_id'=>(int)$appointment['appointment_id'],
                    'date'=>$date,
                    'year'=>$year,
                    'month'=>$month,
                    'time'=>$time,
                    'day'=>$day,
                    'status'=>$appointment['status'],
                    'service_name'=>$appointment['service_name']
                ];
            }
            $json['list']=$list;
            $json['response'] = array(
                'status' => 1,
                'msg'   => 'Get Appointment Success'
            );
        }
        
        
        $this->response->setOutput(json_encode($json));
    }
}
