import React from 'react';
import _ from 'lodash/fp';
import SingleRow from './row/SingleRow';
import FullRow from './row/FullRow';

const studentFullName = (student) => (
  `${_.toString(student.name)} ${_.toString(student.first_surname)} ${_.toString(student.second_surname)}`
);

const TableRow = ({
  courseMember,
  isUndefined,
  isAllTermsSelected,
  onValueChange,
}) => (
  <div className="grades-table-row">
    <div className="flex flex-col justify-center w-40 border-r border-gray-200">
      <p className="text-lg font-semibold tracking-tight">
        {studentFullName(courseMember.student)}
      </p>
    </div>
    {isUndefined && (
      <SingleRow
        courseLessons={courseMember.lessons}
        onValueChange={onValueChange}
        mark={courseMember.courseMark}
      />
    )}

    {!isUndefined && isAllTermsSelected && (
      <FullRow
        courseTerms={courseMember.terms}
        onValueChange={onValueChange}
        courseLessons={courseMember.lessons}
        courseMark={courseMember.courseMark}
      />
    )}

    {!isUndefined && !isAllTermsSelected && (
      <SingleRow
        courseLessons={courseMember.terms[0].lessons}
        onValueChange={onValueChange}
        mark={courseMember.terms[0].termMark}
      />
    )}
  </div>
);

export default TableRow;