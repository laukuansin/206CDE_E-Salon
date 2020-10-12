<?php
class ControllerApiAppointment extends Controller {
    public function getAppointmentList()
    {
        $this->load->model('appointment/appointment');
        $data=array(
            'filter_status'=>3
        );
        $appointmentList=$this->model_appointment_appointment->getAppointmentList($data);
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
                    'worker_name'=>$appointment['user_name'],
                    'customer_name'=>$appointment['customer_name'],
                    'service_name'=>$appointment['services']
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
    public function updateAppointmentStatus()
    {
        $json = array();
        $this->load->model('appointment/appointment');

        
        if(isset($this->request->post['appointment_id']) && isset($this->request->post['status_id'])){
            if($this->request->post['status_id']=="1")
            {
                 $this->model_appointment_appointment->acceptAppointment($this->request->post['appointment_id']);
            }
            else{
                $this->model_appointment_appointment->rejectAppointment($this->request->post['appointment_id']);

            }

            $json['response'] = [
                'status' => 1,
                'msg'   => 'Update Appointment successfully.'
            ];
        } else {
            $json['response'] = [
                'status' => 0,
                'msg'   => 'Paramter missing.'
            ];
        }
        $this->response->setOutput(json_encode($json));
    }
}
