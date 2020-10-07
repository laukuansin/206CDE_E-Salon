<?php

	class ControllerApiUserGroup extends Controller{
		public function getUserGroup(){
			$this->load->model('user/user_group');
			$userGroupResults = $this->model_user_user_group->getUserGroups();

			$userGroup['user_group'] = array();
			foreach($userGroupResults as $userGroupResult){
				$userGroup['user_group'][] = array(
					'user_group_id' => $userGroupResult['user_group_id'],
					'name'			=> $userGroupResult['name']
				);
			}

			$this->response->addHeader('Content-Type: application/json');
			$this->response->setOutput(json_encode($userGroup));
		}
	}

?>