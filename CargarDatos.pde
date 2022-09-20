Boton loadData;




void loadData(String nameData, float newData) {
  table.addColumn(nameData, Table.FLOAT);
    
  TableRow newRow = table.addRow();
  newRow.setFloat(nameData, newData);
}

void saveNewData() {
  saveTable(table, "data/datos - copia.csv", "csv");
}
