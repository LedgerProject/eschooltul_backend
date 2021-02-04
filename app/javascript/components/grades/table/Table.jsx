import React from 'react';
import _ from 'lodash/fp';
import TableHeader from './TableHeader';
import TableRow from './TableRow';

const BASE_TABLE_WIDTH = 179;
const COLUMN_WIDTH = 128;
const BORDER_WIDTH = 1;
const EXTRA_MARK = 1;

const widthToString = (width = 0) => `${BASE_TABLE_WIDTH + width}px`;

const calculateNumberOfLessons = _.flow(
  _.flatMap('lessons'),
  _.size,
);

// TODO: refactor this function
const calculateTableWidth = (courseMembers, isSelectedTerm) => {
  if (_.isEmpty(courseMembers)) {
    return widthToString();
  }

  const courseMember = courseMembers[0];

  if (_.isUndefined(courseMember.terms)) {
    const numberOfLessons = _.size(courseMember.lessons) + EXTRA_MARK;
    const additionalWidth = numberOfLessons * COLUMN_WIDTH;
    return widthToString(additionalWidth);
  }

  const numberOfterms = _.size(courseMember.terms);
  const numberOfLessons = calculateNumberOfLessons(courseMember.terms) + EXTRA_MARK;
  const numberOfUntermedLessons = _.size(courseMember.lessons);
  const termsSize = numberOfterms * COLUMN_WIDTH;
  const lessonsSize = (numberOfLessons + numberOfUntermedLessons) * COLUMN_WIDTH;
  const selectedTerm = isSelectedTerm ? COLUMN_WIDTH + COLUMN_WIDTH : 0;
  const borderSize = numberOfterms * BORDER_WIDTH;

  return widthToString(termsSize + lessonsSize - selectedTerm + borderSize);
};

const Table = ({ courseMembers, selectedTerm, onValueChange }) => (
  <div className="overflow-x-scroll w-full max-w-full">
    <div
      className="grades-table"
      style={{ width: calculateTableWidth(courseMembers, !_.isUndefined(selectedTerm)) }}
    >
      { !_.isEmpty(courseMembers) && (
      <>
        <TableHeader
          courseMember={courseMembers[0]}
          isUndefined={_.isUndefined(courseMembers[0].terms)}
          isAllTermsSelected={_.gt(_.size(courseMembers[0].terms), 1)}
        />
        <div className="grades-table-body">
          { _.map((courseMember) => (
            <TableRow
              key={courseMember.student.id}
              courseMember={courseMember}
              isUndefined={_.isUndefined(courseMember.terms)}
              isAllTermsSelected={_.gt(_.size(courseMember.terms), 1)}
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
