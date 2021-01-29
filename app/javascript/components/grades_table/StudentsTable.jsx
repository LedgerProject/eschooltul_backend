import React from 'react';
import _ from 'lodash/fp';
import StudentTableHeader from './StudentTableHeader';
import StudentTableRow from './StudentsTableRow';
import Button from './Button';

const BASE_TABLE_WIDTH = 179;
const COLUMN_WIDTH = 128;
const BORDER_WIDTH = 1;
const EXTRA_MARK = 1;

const widthToString = (width = 0) => BASE_TABLE_WIDTH + width + 'px';

const calculateNumberOfLessons = _.flow(
  _.flatMap('lessons'),
  _.size,
)
// TODO: Lessons without term when using terms
const calculateWidth = (courseMembers) => {
  if(_.isEmpty(courseMembers)){
    return widthToString();
  }

  const courseMember = courseMembers[0];

  if(_.isUndefined(courseMember.terms)){
    const numberOfLessons = _.size(courseMember.lessons) + EXTRA_MARK;
    const additionalWidth = numberOfLessons * COLUMN_WIDTH; 
    return widthToString(additionalWidth);
  }

  const numberOfterms = _.size(courseMember.terms);
  const numberOfLessons = calculateNumberOfLessons(courseMember.terms) + EXTRA_MARK;
  const termsSize = numberOfterms * COLUMN_WIDTH;
  const lessonsSize = numberOfLessons * COLUMN_WIDTH;
  const borderSize = numberOfterms * BORDER_WIDTH;

  return widthToString(termsSize + lessonsSize + borderSize);
}

const StudentsTable = (props) => (
  <div className="overflow-x-scroll w-full">
    <div className="grades-table" style={{width: calculateWidth(props.courseMembers)}}>
      {!_.isEmpty(props.courseMembers) && (
        <StudentTableHeader 
          isUndefined={_.isUndefined(props.courseMembers[0].terms)}
          isAllTermsSelected={_.gt(_.size(props.courseMembers[0].terms), 1)}
          courseMember={props.courseMembers[0]}
        />
      )}
      <div className="grades-table-body">
        {props.courseMembers.map((courseMember, index) => (
          <StudentTableRow 
            key={courseMember.student.id} 
            courseMember={courseMember} 
            isUndefined={_.isUndefined(courseMember.terms)}
            isAllTermsSelected={_.gt(_.size(courseMember.terms), 1)}
            onValueChange={props.onValueChange}
          />
        ))}
      </div>
    </div>
    <div className="mt-8 flex justify-end items-stretch">
      <Button 
        url={`/grades/courses/${props.selectedCourse.id}/lessons`}
        colors="bg-green-500 hover:bg-green-900"
        icon="fas fa-book"
        text="Lessons"
      />
      <Button 
        url={`/grades/courses/${props.selectedCourse.id}/terms`}
        colors="bg-blue-500 hover:bg-blue-900 ml-2"
        icon="fas fa-calendar-alt"
        text="Terms"
      />
    </div>
  </div>
);

export default StudentsTable;
