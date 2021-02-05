import _ from 'lodash/fp';

export const flatAllMarks = _.flatMap('marks');

const createMark = (id, value, studentID, remarkableID, remarkableType) => ({
  id,
  value,
  student_id: studentID,
  remarkable_id: remarkableID,
  remarkable_type: remarkableType,
});

const findMark = (marks, studentID, remarkableID, remarkableType) => {
  const markIndex = _.findIndex({
    student_id: studentID,
    remarkable_id: remarkableID,
    remarkable_type: remarkableType,
  })(marks);

  if (_.lt(markIndex, 0)) {
    return createMark(null, null, studentID, remarkableID, remarkableType);
  }

  return createMark(
    marks[markIndex].id,
    marks[markIndex].value,
    marks[markIndex].student_id,
    marks[markIndex].remarkable_id,
    marks[markIndex].remarkable_type,
  );
};

export default findMark;
