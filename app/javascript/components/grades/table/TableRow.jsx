import React from 'react';
import _ from 'lodash/fp';
import IconSubmitButton from '../buttons/IconSubmitButton';
import LessonsGradesRow from './row/LessonsGradesRow';
import TermsGradesRow from './row/TermsGradesRow';

const studentFullName = (student) => (
  `${_.toString(student.name)} ${_.toString(student.first_surname)} ${_.toString(student.second_surname)}`
);

const TableRow = ({
  course,
  courseMember,
  selectedTerm,
  onValueChange,
}) => (
  <div className="grades-table-row">
    <div className="flex flex-col justify-center w-52 max-w-52 min-w-52 border-r border-gray-200">
      <p className="text-lg font-semibold tracking-tight">
        {studentFullName(courseMember.student)}
        <IconSubmitButton
          url={`/report/${courseMember.student.id}.pdf?course_id=${course.id}`}
          className="btn-sm text-red-500"
          iconClass="fas fa-file-pdf"
        />
        {!_.isEmpty(courseMember.report.tx) && (
          <IconSubmitButton
            url={`/validators/${courseMember.report.hash}`}
            className="btn-sm text-green-500"
            iconClass="fas fa-lock"
          />
        )}
      </p>
    </div>
    {_.isUndefined(courseMember.terms) && (
      <LessonsGradesRow
        courseLessons={courseMember.lessons}
        mark={courseMember.courseMark}
        onValueChange={onValueChange}
      />
    )}
    {(!_.isUndefined(courseMember.terms) && !_.isUndefined(selectedTerm)) && (
      <LessonsGradesRow
        courseLessons={courseMember.terms[0].lessons}
        mark={courseMember.terms[0].termMark}
        onValueChange={onValueChange}
      />
    )}
    {(!_.isUndefined(courseMember.terms) && _.isUndefined(selectedTerm)) && (
      <TermsGradesRow
        courseTerms={courseMember.terms}
        courseLessons={courseMember.lessons}
        mark={courseMember.courseMark}
        onValueChange={onValueChange}
      />
    )}
  </div>
);
export default TableRow;
