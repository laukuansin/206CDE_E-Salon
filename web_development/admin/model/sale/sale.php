<?php
class ModelSaleSale extends Model {
    public function addSale($data)
    {
        $this->db->query("INSERT INTO `" . DB_PREFIX . "appointment_sales` SET appointment_id = '" . (int)$data['appointment_id'] . "', worker_id = '" . (int)$data['worker_id'] . "', customer_id = '" . (int)$data['customer_id']. "', date_time = NOW()");
		
		return $this->db->getLastId();
    }
    public function addSaleItem($data)
    {
        $this->db->query("INSERT INTO `" . DB_PREFIX . "appointment_sales_item` SET appointment_sales_id = '" . (int)$data['appointment_sales_id'] . "', service_id = '" . (int)$data['service_id'] . "', qty = '" . (int)$data['qty']. "'");
		
    }
}
?>