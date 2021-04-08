import React from 'react';
import { CSVLink } from 'react-csv';
import SubmitButton from './buttons/SubmitButton';
import I18n from '../../i18n-js/index.js.erb';

const GradesFooter = ({
  onSave, dataCSV, courseName,
}) => (
  <div className="mt-8 flex justify-start items-stretch">
    <SubmitButton
      onClick={onSave}
      className="bg-green-500 hover:bg-green-900"
      iconClass="far fa-save"
      text={I18n.t('grades.save')}
    />
    <CSVLink data={dataCSV} filename={`Students${courseName}.csv`}>
      <SubmitButton
        className="bg-blue-500 hover:bg-blue-900 ml-2"
        iconClass="fas fa-file-csv"
        text="Export to CSV"
      />
    </CSVLink>
  </div>
);

export default GradesFooter;
