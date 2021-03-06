/*
 * vim:expandtab:shiftwidth=8:tabstop=8:
 *
 * Copyright CEA/DAM/DIF  (2008)
 * contributeur : Philippe DENIEL   philippe.deniel@cea.fr
 *                Thomas LEIBOVICI  thomas.leibovici@cea.fr
 *
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 3 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301 USA
 *
 * ---------------------------------------
 */

/**
 * \file    nfs4_op_nverify.c
 * \brief   Routines used for managing the NFS4 COMPOUND functions.
 *
 * Routines used for managing the NFS4 COMPOUND functions.
 *
 *
 */
#include "config.h"
#include "log.h"
#include "nfs4.h"
#include "nfs_core.h"
#include "cache_inode.h"
#include "nfs_proto_functions.h"
#include "nfs_proto_tools.h"
#include "nfs_tools.h"

/**
 *
 * @brief Implemtation of NFS4_OP_NVERIFY
 *
 * This function implements the NFS4_OP_NVERIFY operation.
 *
 * @param[in]     op   Arguments for nfs4_op
 * @param[in,out] data Compound request's data
 * @param[out]    resp Results for nfs4_op
 *
 * @return per RFC 5661, p. 369
 *
 */

#define arg_NVERIFY4 op->nfs_argop4_u.opnverify
#define res_NVERIFY4 resp->nfs_resop4_u.opnverify

int nfs4_op_nverify(struct nfs_argop4 *op,
                    compound_data_t *data,
                    struct nfs_resop4 *resp)
{
        fattr4               file_attr4;
        int                  rc = 0;

        resp->resop = NFS4_OP_NVERIFY;
        res_NVERIFY4.status = NFS4_OK;

        /* Do basic checks on a filehandle */
        res_NVERIFY4.status = nfs4_sanity_check_FH(data, NO_FILE_TYPE, false);
        if (res_NVERIFY4.status != NFS4_OK) {
                return res_NVERIFY4.status;
        }

        /* operation is always permitted on pseudofs */
        if (nfs4_Is_Fh_Pseudo(&(data->currentFH))) {
                res_NVERIFY4.status = NFS4_OK;
                return res_NVERIFY4.status;
        }

        /* Get only attributes that are allowed to be read */
        if (!nfs4_Fattr_Check_Access(&arg_NVERIFY4.obj_attributes,
                                    FATTR4_ATTR_READ)) {
                res_NVERIFY4.status = NFS4ERR_INVAL;
                return res_NVERIFY4.status;
        }

        /* Ask only for supported attributes */
        if (!nfs4_Fattr_Supported(&arg_NVERIFY4.obj_attributes)) {
                res_NVERIFY4.status = NFS4ERR_ATTRNOTSUPP;
                return res_NVERIFY4.status;
        }

        if (cache_entry_To_Fattr(data->current_entry,
                                 &file_attr4,
                                 data,
                                 &(data->currentFH),
                                 &(arg_NVERIFY4.obj_attributes.attrmask))
           != 0) {
                res_NVERIFY4.status = NFS4ERR_SERVERFAULT;
                return res_NVERIFY4.status;
        }

        if ((rc = nfs4_Fattr_cmp(&(arg_NVERIFY4.obj_attributes),
                                 &file_attr4)) == false) {
                res_NVERIFY4.status = NFS4_OK;
        } else {
                if(rc == -1) {
                        res_NVERIFY4.status = NFS4ERR_INVAL;
                } else {
                        res_NVERIFY4.status = NFS4ERR_SAME;
                }
        }

        nfs4_Fattr_Free(&file_attr4);
        return res_NVERIFY4.status;
} /* nfs4_op_nverify */

/**
 * @brief Free memory allocated for NVERIFY result
 *
 * This function frees any memory allocated for the result of the
 * NFS4_OP_NVERIFY operation.
 *
 * @param[in] resp nfs4_op results
 */
void nfs4_op_nverify_Free(NVERIFY4res *resp)
{
        return;
} /* nfs4_op_nverify_Free */
