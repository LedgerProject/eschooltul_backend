import React from 'react';
import SubmitButton from './buttons/SubmitButton';
import Button from './buttons/Button';
import I18n from '../../i18n-js/index.js.erb';

const GradesFooter = ({ onSave, selectedCourseID }) => (
  <div className="mt-8 flex justify-between items-stretch">
    <div>
      <SubmitButton
        onClick={onSave}
        className="bg-green-500 hover:bg-green-900"
        iconClass="far fa-save"
        text={I18n.t('grades.save')}
      />
    </div>
    <div>
      <Button
        url={`/grades/courses/${selectedCourseID}/lessons`}
        className="bg-purple-500 hover:bg-purple-900"
        iconClass="fas fa-book"
        text={I18n.t('grades.lessons')}
      />
      <Button
        url={`/grades/courses/${selectedCourseID}/terms`}
        className="bg-blue-500 hover:bg-blue-900 ml-2"
        iconClass="fas fa-calendar-alt"
        text={I18n.t('grades.terms')}
      />
    </div>
  </div>
);

export default GradesFooter;
