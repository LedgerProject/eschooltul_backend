import React from 'react';
import _ from 'lodash/fp';
import TableHeader from './TableHeader';
import TableRow from './TableRow';

const BASE_TABLE_WIDTH = 208;
const COLUMN_WIDTH = 128;
const EXTRA_MARK = 1;

const widthToString = (width = 0) => `${BASE_TABLE_WIDTH + width}px`;

const calculateTableWidth = (courseMember, selectedTerm) => {
  if (_.isUndefined(courseMember.terms)) {
    const numberOfLessons = _.size(courseMember.lessons) + EXTRA_MARK;
    const additionalWidth = numberOfLessons * COLUMN_WIDTH;
    return widthToString(additionalWidth);
  }
  if (!_.isUndefined(selectedTerm)) {
    const term = courseMember.terms[0];
    const numberOfLessons = _.size(term.lessons) + EXTRA_MARK;
    const additionalWidth = numberOfLessons * COLUMN_WIDTH;
    return widthToString(additionalWidth);
  }

  const numberOfterms = _.size(courseMember.terms) + EXTRA_MARK;
  const numberOfLessons = _.size(courseMember.lessons);
  const additionalWidth = (numberOfLessons + numberOfterms) * COLUMN_WIDTH;
  return widthToString(additionalWidth);
};

const Table = ({
  courseMembers, selectedTerm, onValueChange, course,
}) => (
  <div className="overflow-x-scroll w-full max-w-full">
    <div
      className="grades-table"
      style={{ width: calculateTableWidth(courseMembers[0], selectedTerm) }}
    >
      { !_.isEmpty(courseMembers) && (
      <>
        <TableHeader
          courseMember={courseMembers[0]}
          selectedTerm={selectedTerm}
        />
        <div className="grades-table-body">
          { _.map((courseMember) => (
            <TableRow
              key={courseMember.student.id}
              course={course}
              courseMember={courseMember}
              selectedTerm={selectedTerm}
              onValueChange={onValueChange}
            />
          ))(courseMembers)}
        </div>
      </>
      )}
    </div>
  </div>
);

export default Table;
